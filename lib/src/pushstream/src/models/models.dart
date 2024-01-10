// ignore_for_file: constant_identifier_names

import '../../../../push_restapi_dart.dart';

class PushStreamInitializeOptions {
  final PushStreamFilter? filter;
  final PushStreamConnection? connection;
  final bool raw;
  final ENV env;
  final String? overrideAccount;

  PushStreamInitializeOptions({
    this.filter,
    this.connection,
    this.raw = false,
    this.overrideAccount,
    this.env = ENV.staging,
  });

  static PushStreamInitializeOptions defaut() {
    return PushStreamInitializeOptions(connection: PushStreamConnection());
  }
}

class PushStreamFilter {
  final List<String>? channels;
  final List<String>? chats;

  PushStreamFilter({this.channels, this.chats});
}

class PushStreamConnection {
  final bool auto;
  final int retries;

  PushStreamConnection({
    this.auto = true,
    this.retries = 3,
  });
}

enum STREAM {
  PROFILE,
  ENCRYPTION,
  NOTIF,
  NOTIF_OPS,
  CHAT,
  CHAT_OPS,
  CONNECT,
  DISCONNECT,
}

extension STREAMExtension on STREAM {
  String get value {
    switch (this) {
      case STREAM.PROFILE:
        return 'STREAM.PROFILE';
      case STREAM.ENCRYPTION:
        return 'STREAM.ENCRYPTION';
      case STREAM.NOTIF:
        return 'STREAM.NOTIF';
      case STREAM.NOTIF_OPS:
        return 'STREAM.NOTIF_OPS';
      case STREAM.CHAT:
        return 'STREAM.CHAT';
      case STREAM.CHAT_OPS:
        return 'STREAM.CHAT_OPS';
      case STREAM.CONNECT:
        return 'STREAM.CONNECT';
      case STREAM.DISCONNECT:
        return 'STREAM.DISCONNECT';
    }
  }
}

enum ProposedEventNames {
  Message,
  Request,
  Accept,
  Reject,
  LeaveGroup,
  JoinGroup,
  CreateGroup,
  UpdateGroup,
  Remove,
}

class GroupEventType {
  static final createGroup = 'createGroup';
  static final updateGroup = 'updateGroup';
  static final joinGroup = 'joinGroup';
  static final leaveGroup = 'leaveGroup';
  static final remove = 'remove';
}

class MessageEventType {
  static final message = 'message';
  static final request = 'request';
  static final accept = 'accept';
  static final reject = 'reject';
}

class MessageEvent {
  final String event;
  final String origin;
  final String timestamp;
  final String chatId;
  final String from;
  final List<String> to;
  final MessageContent message;
  final MessageMeta meta;
  final String reference;
  final MessageRawData? raw;

  MessageEvent({
    required this.event,
    required this.origin,
    required this.timestamp,
    required this.chatId,
    required this.from,
    required this.to,
    required this.message,
    required this.meta,
    required this.reference,
    this.raw,
  });
}

class MessageContent {
  final String type;
  final String content;

  MessageContent({
    required this.type,
    required this.content,
  });
}

class MessageMeta {
  final bool group;

  MessageMeta({
    required this.group,
  });
}

class MessageRawData {
  final String fromCAIP10;
  final String toCAIP10;
  final String fromDID;
  final String toDID;
  final String encType;
  final String encryptedSecret;
  final String signature;
  final String sigType;
  final String verificationProof;
  final String previousReference;

  MessageRawData({
    required this.fromCAIP10,
    required this.toCAIP10,
    required this.fromDID,
    required this.toDID,
    required this.encType,
    required this.encryptedSecret,
    required this.signature,
    required this.sigType,
    required this.verificationProof,
    required this.previousReference,
  });

  factory MessageRawData.fromJson(Map<String, dynamic> data) {
    return MessageRawData(
      fromCAIP10: data['fromCAIP10'],
      toCAIP10: data['toCAIP10'],
      fromDID: data['fromDID'],
      toDID: data['toDID'],
      encType: data['encType'],
      encryptedSecret: data['encryptedSecret'],
      signature: data['signature'],
      sigType: data['sigType'],
      verificationProof: data['verificationProof'],
      previousReference: data['link'],
    );
  }
}

class MessageOrigin {
  static const other = 'other';
  static const self = 'self';
}
