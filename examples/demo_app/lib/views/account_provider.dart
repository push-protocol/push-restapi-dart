import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

import '../__lib.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';
// import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:web3dart/web3dart.dart' as web3;
// import 'package:ethers/signers/wallet.dart' as ether;

final accountProvider = ChangeNotifierProvider((ref) => AccountProvider(ref));

class AccountProvider extends ChangeNotifier {
  final Ref ref;
  late SharedPreferences prefs;

  AccountProvider(this.ref) {
    init();
  }

  final _prefsKey = 'accounts';
  final ENV env = ENV.staging;

  init() async {
    prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_prefsKey);
    if (data != null) {
      _accounts = List.generate(
          data.length, (index) => DemoUser.fromJson(jsonDecode(data[index])));
      notifyListeners();
    }
  }

  // Wallet? pushWallet;
  PushAPI? pushUser;
  String get account => pushUser?.account ?? '';

  List<DemoUser> _accounts = [];
  List<DemoUser> get accounts => _accounts;

  generateNewUser() async {
    // Dummy Wallet Addresses and signers
    var random = Random.secure();
    final wallet = web3.EthPrivateKey.createRandom(random);
    _accounts = [
      ..._accounts,
      DemoUser(
        mnemonic: wallet.privateKey,
        address: wallet.address.hexEip55,
      )
    ];

    prefs.setStringList(
      _prefsKey,
      List.generate(
        _accounts.length,
        (index) => jsonEncode(_accounts[index].toJson()),
      ),
    );

    notifyListeners();

    final user = PushAPI.initialize(signer: Web3Signer(wallet));

    return user;
  }

  Future<void> connectWallet(DemoUser user) async {
    try {
      showLoadingDialog();

      final wallet = web3.EthPrivateKey(Uint8List.fromList(user.mnemonic));

      pushUser = await PushAPI.initialize(
        signer: Web3Signer(wallet),
        options: PushAPIInitializeOptions(
          account: user.address.toLowerCase(),
          env: env,
          showHttpLog: true
        ),
      );

      creatSocketConnection();

      //Spaces
      ref.read(popularSpaceProvider).loadSpaces();
      ref.read(spaceRequestsProvider).loadRequests();
      ref.read(yourSpacesProvider.notifier).onRefresh();

      //CHAT
      ref.read(requestsProvider).loadRequests();
      ref.read(conversationsProvider).reset();

      notifyListeners();
      pop();
    } catch (e) {
      print(e);
      pop();
    }
  }

  // io.Socket? pushSDKSocket;
  PushStream? pushStream;
  Future<void> creatSocketConnection() async {
    pushStream = await pushUser!.initStream(
      listen: [
        STREAM.CHAT,
        STREAM.CHAT_OPS,
      ],
      options: PushStreamInitializeOptions(
        env: env,
        filter: PushStreamFilter(
          channels: ['*'],
          chats: ['*'],
        ),
      ),
    );

    pushStream!.on(STREAM.CONNECT.value, (data) {
      print(' NOTIFICATION EVENTS.CONNECT: $data');
    });

    pushStream!.on(STREAM.DISCONNECT.value, (data) {
      log('Stream Disconnected');
    });
    pushStream!.on(STREAM.CHAT.value, (dynamic data) {
      log('Stream STREAM.CHAT $data');
      ref.read(conversationsProvider).onReceiveSocket(data);
      ref.read(requestsProvider).addReqestFromSocket(
            Feeds(
              chatId: data['chatId'],
              intentSentBy: data['groupName'] ?? data['from'],
            ),
          );
    });
    pushStream!.on(STREAM.CHAT_OPS.value, (dynamic data) {
      log('Stream STREAM.CHAT_OPS $data');

      ref.read(conversationsProvider).onReceiveSocket(data);
      ref.read(requestsProvider).addReqestFromSocket(
            Feeds(
              chatId: data['chatId'],
              intentSentBy: data['groupName'] ?? data['from'],
            ),
          );
    });

    await pushStream!.connect();

    // pushStream!.on(EVENTS.CHAT_RECEIVED_MESSAGE, (message) {
    //   print('CHAT NOTIFICATION EVENTS.CHAT_RECEIVED_MESSAGE: $message');
    //   ref.read(conversationsProvider).onReceiveSocket(message);
    // });

    // To get group creation or updation events
    // pushStream!.on(EVENTS.CHAT_GROUPS, (groupInfo) {
    //   print('CHAT NOTIFICATION EVENTS.CHAT_GROUPS: $groupInfo');

    //   final type = (groupInfo as Map<String, dynamic>)['eventType'];
    //   final recipients = (groupInfo['to'] as List?) ?? [];
    //   final from = groupInfo['from'];

    //   if ((type == 'create' && from != walletToPCAIP10(pushUser!.account)) ||
    //       (type == 'request' &&
    //           recipients.contains(walletToPCAIP10(pushUser!.account)))) {
    //     ref.read(requestsProvider).addReqestFromSocket(
    //           Feeds(
    //             chatId: groupInfo['chatId'],
    //             intentSentBy: groupInfo['groupName'] ?? groupInfo['from'],
    //           ),
    //         );
    //     return;
    //   }
    //   ref.read(conversationsProvider).onReceiveSocket(groupInfo);
    // });

    // To get messages in realtime
    // pushStream!.on(EVENTS.CHAT_RECEIVED_MESSAGE, (message) {
    //   print('CHAT NOTIFICATION EVENTS.CHAT_RECEIVED_MESSAGE: $message');
    //   ref.read(conversationsProvider).onReceiveSocket(message);
    // });

    /*
    try {
      pushStream = await PushStream.initialize(
        account: pushUser!.account,
        listen: [STREAM.ALL],
      );

      final options = SocketInputOptions(
        user: pushUser!.account,
        env: ENV.staging,
        socketType: SOCKETTYPES.CHAT,
        socketOptions: SocketOptions(
          autoConnect: true,
          reconnectionAttempts: 3,
        ),
      );

      pushSDKSocket = await createSocketConnection(options);
      if (pushSDKSocket == null) {
        throw Exception('PushSDKSocket Connection Failed');
      }

      pushSDKSocket!.connect();

      pushSDKSocket!.on(
        EVENTS.CONNECT,
        (data) async {
          print(' NOTIFICATION EVENTS.CONNECT: $data');
        },
      );
      // To get messages in realtime
      pushSDKSocket!.on(EVENTS.CHAT_RECEIVED_MESSAGE, (message) {
        print('CHAT NOTIFICATION EVENTS.CHAT_RECEIVED_MESSAGE: $message');
        ref.read(conversationsProvider).onReceiveSocket(message);
      });

      pushSDKSocket!.on(EVENTS.SPACES, (groupInfo) {
        print('SPACES NOTIFICATION EVENTS.SPACES: $groupInfo');

        final type = (groupInfo as Map<String, dynamic>)['eventType'];

        if (type == 'stop') {
          //Refresh Hosted by you and For you tabs to reflect ended spaces
          ref.read(yourSpacesProvider).onRefresh();
        }

        if (type == 'create') {
          //This is a fix to complement the structure of the space retured by socket
          var spaceFeed = SpaceFeeds.fromJson(groupInfo);
          spaceFeed.spaceInformation = SpaceDTO.fromJson(groupInfo);

          ref.read(spaceRequestsProvider).addReqestFromSocket(spaceFeed);
          return;
        }
      });

      // To get group creation or updation events
      pushSDKSocket!.on(EVENTS.CHAT_GROUPS, (groupInfo) {
        print('CHAT NOTIFICATION EVENTS.CHAT_GROUPS: $groupInfo');

        final type = (groupInfo as Map<String, dynamic>)['eventType'];
        final recipients = (groupInfo['to'] as List?) ?? [];
        final from = groupInfo['from'];

        if ((type == 'create' && from != walletToPCAIP10(pushUser!.account)) ||
            (type == 'request' &&
                recipients.contains(walletToPCAIP10(pushUser!.account)))) {
          ref.read(requestsProvider).addReqestFromSocket(
                Feeds(
                  chatId: groupInfo['chatId'],
                  intentSentBy: groupInfo['groupName'] ?? groupInfo['from'],
                ),
              );
          return;
        }
        ref.read(conversationsProvider).onReceiveSocket(groupInfo);
      });

      // To get realtime updates for spaces
      pushSDKSocket!.on(
        EVENTS.SPACES_MESSAGES,
        (data) async {
          final message = data as Map<String, dynamic>;
          print(
              'SPACES NOTIFICATION EVENTS.SPACES_MESSAGES messageCategory ${message['messageCategory']} messageType ${message['messageType']}');
          for (var element in message.keys) {
            print('$element -> ${message[element]}');
          }

          // Check if the message is a chat meta message or chat user activity message
          if (message['messageCategory'] == 'Chat' &&
              (message['messageType'] == MessageType.META ||
                  message['messageType'] == MessageType.USER_ACTIVITY)) {
            ref.read(liveSpaceProvider).onReceiveMetaMessage(message);
          }

          //Check if space was ended
          if (message['messageCategory'] == 'Chat' &&
              message['messageContent'] == CHAT.META_SPACE_END &&
              message["fromDID"] != walletToPCAIP10(pushUser!.account)) {
            ref
                .read(liveSpaceProvider)
                .onReceiveSpaceEndedData(message["chatId"]);
          }
          //Check if promotion invite was sent
          if (message['messageCategory'] == 'Chat' &&
              message['messageContent'] ==
                  CHAT.META_SPACE_LISTENER_PROMOTE_INVITE) {
            try {
              final invitedUsers = message["messageObj"]["info"]['affected'];

              if (invitedUsers.contains(pushUser?.account)) {
                ref
                    .read(liveSpaceProvider)
                    .onReceivePromotionInvite(message["chatId"]);
              }
            } catch (e) {}
          }

          if (message['messageCategory'] == 'Chat' &&
              (message['messageType'] == MessageType.REACTION)) {
            try {
              final reaction = data['messageObj']['content'];
              final reactionFrom = data['fromDID'];

              ref
                  .read(liveSpaceProvider)
                  .onReceiveReaction(reaction: reaction, from: reactionFrom);
            } catch (e) {
              print(e);
            }
          }
        },
      );

      pushSDKSocket!.on(
        EVENTS.DISCONNECT,
        (data) {
          print(' NOTIFICATION EVENTS.DISCONNECT: $data');
        },
      );
    } catch (e) {
      print(e);
    }
    */
  }

  logOut() {
    // pushWallet = null;
    pushUser = null;
    if (pushStream != null) {
      pushStream!.disconnect();
      pushStream = null;
    }

    notifyListeners();
  }
}

class DemoUser {
  final List<int> mnemonic;
  final String address;

  DemoUser({
    required this.mnemonic,
    required this.address,
  });

  factory DemoUser.fromJson(Map<String, dynamic> json) {
    return DemoUser(
      mnemonic: (json['mnemonic'] as List)
          .map((e) => int.parse(e.toString()))
          .toList(),
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mnemonic': mnemonic,
      'address': address,
    };
  }
}
