import 'package:events_emitter/events_emitter.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../push_restapi_dart.dart';

class PushStream extends EventEmitter {
  io.Socket? pushChatSocket;
  io.Socket? pushNotificationSocket;

  late final String _account;
  late final bool _raw;
  late final PushStreamInitializeOptions _options;
  late final List<STREAM> _listen;
  late final Signer? _signer;

  late final Chat chatInstance;
  PushStream({
    required PushStreamInitializeOptions options,
    required String account,
    required List<STREAM> listen,
    Signer? signer,
    String? decryptedPgpPvtKey,
    void Function(ProgressHookType)? progressHook,
    required ENV env,
  }) {
    _account = account;
    _options = options;
    _raw = options.raw;
    _listen = listen;
    _signer = signer;

    chatInstance = Chat(
      signer: signer,
      env: env,
      account: _account,
      decryptedPgpPvtKey: decryptedPgpPvtKey,
      progressHook: progressHook,
    );
  }

  static Future<PushStream> initialize({
    required String account,
    required ENV env,
    required List<STREAM> listen,
    Signer? signer,
    String? decryptedPgpPvtKey,
    PushStreamInitializeOptions? options,
    void Function(ProgressHookType)? progressHook,
  }) async {
    final defaultOptions = PushStreamInitializeOptions.default_();

    if (listen.isEmpty) {
      throw Exception(
          'The listen property must have at least one STREAM type.');
    }

    final settings = options ?? defaultOptions;
    final accountToUse = settings.overrideAccount ?? account;

    return PushStream(
        env: env,
        account: accountToUse,
        listen: listen,
        options: settings,
        decryptedPgpPvtKey: decryptedPgpPvtKey,
        signer: signer,
        progressHook: progressHook);
  }

  Future connect() async {
    final shouldInitializeChatSocket = _listen.isNotEmpty ||
        _listen.contains(STREAM.CHAT) ||
        _listen.contains(STREAM.CHAT_OPS);

    final shouldInitializeNotifSocket = _listen.isNotEmpty ||
        _listen.contains(STREAM.NOTIF) ||
        _listen.contains(STREAM.NOTIF_OPS);

    bool isChatSocketConnected = false;
    bool isNotifSocketConnected = false;

    checkAndEmitConnectEvent() {
      if (((shouldInitializeChatSocket && isChatSocketConnected) ||
              !shouldInitializeChatSocket) &&
          ((shouldInitializeChatSocket && isNotifSocketConnected) ||
              !shouldInitializeNotifSocket)) {
        emit(STREAM.CONNECT.value);
        log('Emitted STREAM.CONNECT');
      }
    }

    handleSocketDisconnection(String socketType) async {
      if (socketType == 'chat') {
        isChatSocketConnected = false;
        if (isNotifSocketConnected) {
          if (pushNotificationSocket != null &&
              pushNotificationSocket!.connected) {
            pushNotificationSocket!.disconnect();
          }
        } else {
          // Emit STREAM.DISCONNECT only if the chat socket was already disconnected
          emit(STREAM.DISCONNECT.value);
          log('Emitted STREAM.DISCONNECT ');
        }
      } else if (socketType == 'notif') {
        isNotifSocketConnected = false;
        if (isChatSocketConnected) {
          if (pushChatSocket != null && pushChatSocket!.connected) {
            pushChatSocket!.disconnect();
          }
        } else {
          // Emit STREAM.DISCONNECT only if the chat socket was already disconnected
          emit(STREAM.DISCONNECT.value);
          log('Emitted STREAM.DISCONNECT');
        }
      }
    }

    if (shouldInitializeChatSocket) {
      if (pushChatSocket == null) {
        // If pushNotificationSocket does not exist, create a new socket connection
        pushChatSocket = await createSocketConnection(
          SocketInputOptions(
            user: walletToPCAIP10(_account),
            env: _options.env,
            socketType: 'chat',
            socketOptions: SocketOptions(
              autoConnect: _options.connection.auto,
              reconnectionAttempts: _options.connection.retries,
            ),
          ),
        );

        if (pushChatSocket == null) {
          throw Exception('Push chat socket not connected');
        }
      } else if (!pushChatSocket!.connected) {
        // If pushChatSocket exists but is not connected, attempt to reconnect
        pushChatSocket!.connect();
      } else {
        // If pushChatSocket is already connected
        log('Push chat socket already connected');
      }
    }

    if (shouldInitializeNotifSocket) {
      if (pushNotificationSocket == null) {
        // If pushNotificationSocket does not exist, create a new socket connection
        pushNotificationSocket = await createSocketConnection(
          SocketInputOptions(
            user: walletToPCAIP10(_account),
            env: _options.env,
            socketType: 'notification',
            socketOptions: SocketOptions(
              autoConnect: _options.connection.auto,
              reconnectionAttempts: _options.connection.retries,
            ),
          ),
        );

        if (pushNotificationSocket == null) {
          throw Exception('Push notification socket not connected');
        }
      } else if (!pushNotificationSocket!.connected) {
        // If pushNotificationSocket exists but is not connected, attempt to reconnect
        log('Attempting to reconnect push notification socket...');
        pushNotificationSocket!.connect();
        // Assuming connect() is the method to re-establish connection
      } else {
        // If pushNotificationSocket is already connected
        log('Push notification socket already connected');
      }
    }

    bool shouldEmit(STREAM eventType) {
      if (_listen.isEmpty) {
        return false;
      }

      return _listen.contains(eventType);
    }

    if (pushChatSocket != null) {
      pushChatSocket!.on(EVENTS.CONNECT, (data) async {
        isChatSocketConnected = true;
        checkAndEmitConnectEvent();
        log('Chat Socket Connected (ID: ${pushChatSocket?.id}');
      });

      pushChatSocket!.on(EVENTS.DISCONNECT, (data) async {
        await handleSocketDisconnection('chat');
      });
      pushChatSocket!.on(EVENTS.CHAT_GROUPS, (data) async {
        try {
          final modifiedData = await DataModifier.handleChatGroupEvent(
            data: data,
            includeRaw: _raw,
          );

          modifiedData['event'] =
              DataModifier.convertToProposedName(modifiedData['event']);

          DataModifier.handleToField(modifiedData);

          if (_shouldEmitChat(data['chatId'])) {
            if (data['eventType'] == GroupEventType.joinGroup ||
                data['eventType'] == GroupEventType.leaveGroup ||
                data['eventType'] == MessageEventType.request ||
                data['eventType'] == GroupEventType.remove) {
              if (shouldEmit(STREAM.CHAT)) {
                emit(STREAM.CHAT.value, modifiedData);
              }
            } else {
              if (shouldEmit(STREAM.CHAT_OPS)) {
                emit(STREAM.CHAT_OPS.value, modifiedData);
              }
            }
          }
        } catch (error) {
          log('Error handling CHAT_GROUPS event: $error\tData: $data');
        }
      });

      pushChatSocket!.on(EVENTS.CHAT_RECEIVED_MESSAGE, (data) async {
        try {
          if (data['messageCategory'] == 'Chat' ||
              data['messageCategory'] == 'Request') {
            // Dont call this if read only mode ?
            if (_signer != null) {
              final chat = await chatInstance
                  .decrypt(messagePayloads: [Message.fromJson(data)]);
              data = {
                ...chat[0].toJson(),
                'messageCategory': data['messageCategory'],
                'chatId': data['chatId'],
              };
            }
          }

          final modifiedData = DataModifier.handleChatEvent(data, _raw);
          modifiedData['event'] =
              DataModifier.convertToProposedName(modifiedData['event']);
          DataModifier.handleToField(modifiedData);
          if (_shouldEmitChat(data['chatId'])) {
            if (shouldEmit(STREAM.CHAT)) {
              emit(STREAM.CHAT.value, modifiedData);
            }
          }
        } catch (error) {
          log('Error handling CHAT_RECEIVED_MESSAGE event:$error \t Data:$data');
        }
      });

      pushChatSocket!.on(EVENTS.SPACES, (data) async {
        try {
          final modifiedData =
              DataModifier.handleSpaceEvent(data: data, includeRaw: _raw);
          modifiedData['event'] =
              DataModifier.convertToProposedNameForSpace(modifiedData['event']);

          DataModifier.handleToField(modifiedData);

          if (_shouldEmitSpace(data.spaceId)) {
            if (data.eventType == SpaceEventType.join ||
                data.eventType == SpaceEventType.leave ||
                data.eventType == MessageEventType.request ||
                data.eventType == SpaceEventType.remove ||
                data.eventType == SpaceEventType.start ||
                data.eventType == SpaceEventType.stop) {
              if (shouldEmit(STREAM.SPACE)) {
                emit(STREAM.SPACE.value, modifiedData);
              }
            } else {
              if (shouldEmit(STREAM.SPACE_OPS)) {
                emit(STREAM.SPACE_OPS.value, modifiedData);
              }
            }
          }
        } catch (e) {
          log('Error handling SPACES event: $e, Data: $data');
        }
      });

      pushChatSocket!.on(EVENTS.SPACES_MESSAGES, (data) async {
        try {
          final modifiedData =
              DataModifier.handleSpaceEvent(data: data, includeRaw: _raw);
          modifiedData.event =
              DataModifier.convertToProposedNameForSpace(modifiedData.event);

          DataModifier.handleToField(modifiedData);

          if (_shouldEmitSpace(data.spaceId)) {
            if (shouldEmit(STREAM.SPACE)) {
              emit(STREAM.SPACE.value, modifiedData);
            }
          }
        } catch (e) {
          log('Error handling SPACES event: $e, Data: $data');
        }
      });
    }

    if (pushNotificationSocket != null) {
      pushNotificationSocket!.on(EVENTS.CONNECT, (data) async {
        isNotifSocketConnected = true;
        checkAndEmitConnectEvent();
        log('Notification Socket Connected  (ID: ${pushChatSocket?.id}');
      });

      pushNotificationSocket!.on(EVENTS.DISCONNECT, (data) async {
        await handleSocketDisconnection('notif');
      });

      pushNotificationSocket!.on(EVENTS.USER_FEEDS, (data) async {
        try {
          final modifiedData = DataModifier.mapToNotificationEvent(
            data: data,
            notificationEventType: NotificationEventType.INBOX,
            origin: _account == data.sender ? 'self' : 'other',
            includeRaw: _raw,
          );

          if (_shouldEmitChannel(modifiedData.from)) {
            if (shouldEmit(STREAM.NOTIF)) {
              emit(STREAM.NOTIF.value, modifiedData);
            }
          }
        } catch (error) {
          log('Error handling USER_FEEDS event: $error \tData: $data');
        }
      });

      pushNotificationSocket!.on(EVENTS.USER_SPAM_FEEDS, (data) {
        try {
          final modifiedData = DataModifier.mapToNotificationEvent(
              data: data,
              notificationEventType: NotificationEventType.SPAM,
              origin: _account == data['sender'] ? 'self' : 'other',
              includeRaw: _raw);
          modifiedData.origin =
              _account == modifiedData.from ? 'self' : 'other';
          if (_shouldEmitChannel(modifiedData.from)) {
            if (shouldEmit(STREAM.NOTIF)) {
              emit(STREAM.NOTIF.value, modifiedData);
            }
          }
        } catch (error) {
          log('Error handling USER_SPAM_FEEDS event: $error \tData: $data');
        }
      });
    }
  }

  bool connected() =>
      (pushNotificationSocket != null && pushNotificationSocket!.connected) ||
      (pushChatSocket != null && pushChatSocket!.connected);

  Future disconnect() async {
    if (pushChatSocket != null) {
      pushChatSocket!.disconnect();
    }

    if (pushNotificationSocket != null) {
      pushNotificationSocket!.disconnect();
    }
  }

  bool _shouldEmitChat(String dataChatId) {
    if (_options.filter != null ||
        _options.filter!.chats != null ||
        _options.filter!.chats!.isNotEmpty ||
        _options.filter!.chats!.contains('*')) {
      return true;
    }

    return _options.filter!.chats!.contains(dataChatId);
  }

  bool _shouldEmitChannel(String dataChannelId) {
    if (_options.filter?.channels != null ||
        _options.filter!.channels!.isNotEmpty ||
        _options.filter!.channels!.contains('*')) {
      return true;
    }

    return _options.filter!.channels!.contains(dataChannelId);
  }

  bool _shouldEmitSpace(String dataSpaceId) {
    if (_options.filter?.space != null ||
        _options.filter!.space!.isNotEmpty ||
        _options.filter!.space!.contains('*')) {
      return true;
    }

    return _options.filter!.space!.contains(dataSpaceId);
  }
}
