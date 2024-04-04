// ignore_for_file: constant_identifier_names

import '../../../../push_restapi_dart.dart';

class PushStreamInitializeOptions {
  final PushStreamFilter? filter;
  late final PushStreamConnection connection;
  final bool raw;
  final ENV env;
  final String? overrideAccount;

  PushStreamInitializeOptions({
    this.filter,
    PushStreamConnection? connection,
    this.raw = false,
    this.overrideAccount,
    this.env = ENV.prod,
  }) {
    this.connection = connection ?? PushStreamConnection();
  }

  static PushStreamInitializeOptions default_() {
    return PushStreamInitializeOptions(
      connection: PushStreamConnection(),
    );
  }
}

class PushStreamFilter {
  final List<String>? channels;
  final List<String>? chats;
  final List<String>? space;
  final List<String>? video;

  PushStreamFilter({
    this.channels,
    this.chats,
    this.space,
    this.video,
  });
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
  SPACE,
  SPACE_OPS,
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
      case STREAM.SPACE:
        return 'STREAM.SPACE';
      case STREAM.SPACE_OPS:
        return 'STREAM.SPACE_OPS';
      case STREAM.CHAT_OPS:
        return 'STREAM.CHAT_OPS';
      case STREAM.CONNECT:
        return 'STREAM.CONNECT';
      case STREAM.DISCONNECT:
        return 'STREAM.DISCONNECT';
    }
  }
}

class ProposedEventNames {
  static const Message = 'chat.message';
  static const Request = 'chat.request';
  static const Accept = 'chat.accept';
  static const Reject = 'chat.reject';
  static const LeaveGroup = 'chat.group.participant.leave';
  static const JoinGroup = 'chat.group.participant.join';
  static const CreateGroup = 'chat.group.create';
  static const UpdateGroup = 'chat.group.update';
  static const Remove = 'chat.group.participant.remove';

  static const CreateSpace = 'space.create';
  static const UpdateSpace = 'space.update';
  static const SpaceRequest = 'space.request';
  static const SpaceAccept = 'space.accept';
  static const SpaceReject = 'space.reject';
  static const LeaveSpace = 'space.participant.leave';
  static const JoinSpace = 'space.participant.join';
  static const SpaceRemove = 'space.participant.remove';
  static const StartSpace = 'space.start';
  static const StopSpace = 'space.stop';
}

class GroupEventType {
  static const createGroup = 'createGroup';
  static const updateGroup = 'updateGroup';
  static const joinGroup = 'joinGroup';
  static const leaveGroup = 'leaveGroup';
  static const remove = 'remove';
}

class SpaceEventType {
  static const createSpace = 'createSpace';
  static const updateSpace = 'updateSpace';
  static const join = 'joinSpace';
  static const leave = 'leaveSpace';
  static const remove = 'remove';
  static const stop = 'stop';
  static const start = 'start';
}

class MessageEventType {
  static const message = 'message';
  static const request = 'request';
  static const accept = 'accept';
  static const reject = 'reject';
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

class GroupMeta {
  final String name;
  final String description;
  final String image;
  final String owner;
  final bool private;
  final dynamic rules;

  GroupMeta({
    required this.name,
    required this.description,
    required this.image,
    required this.owner,
    required this.private,
    required this.rules,
  });

  factory GroupMeta.fromJson(Map<String, dynamic> json) {
    return GroupMeta(
      name: json['name'],
      description: json['description'],
      image: json['image'],
      owner: json['owner'],
      private: json['private'],
      rules: json['rules'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'owner': owner,
      'private': private,
      'rules': rules.toJson(),
    };
  }
}
