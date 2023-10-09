import 'dart:convert';

import 'package:push_restapi_dart/push_restapi_dart.dart';

class Message {
  String fromCAIP10;
  String toCAIP10;
  String fromDID;
  String toDID;
  String messageType;
  String messageContent;
  dynamic messageObj;
  String signature;
  String sigType;
  String? link;
  int? timestamp;
  String encType;
  String encryptedSecret;
  bool? deprecated;
  String? deprecatedCode;

  Message({
    required this.fromCAIP10,
    required this.toCAIP10,
    required this.fromDID,
    required this.toDID,
    required this.messageType,
    required this.messageContent,
    this.messageObj,
    required this.signature,
    required this.sigType,
    this.link,
    this.timestamp,
    required this.encType,
    required this.encryptedSecret,
    this.deprecated,
    this.deprecatedCode,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      fromCAIP10: json['fromCAIP10'],
      toCAIP10: json['toCAIP10'],
      fromDID: json['fromDID'],
      toDID: json['toDID'],
      messageType: json['messageType'],
      messageContent: json['messageContent'],
      messageObj: json['messageObj'],
      signature: json['signature'],
      sigType: json['sigType'],
      link: json['link'],
      timestamp: json['timestamp'],
      encType: json['encType'],
      encryptedSecret: json['encryptedSecret'],
      deprecated: json['deprecated'],
      deprecatedCode: json['deprecatedCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['fromCAIP10'] = fromCAIP10;
    data['toCAIP10'] = toCAIP10;
    data['fromDID'] = fromDID;
    data['toDID'] = toDID;
    data['messageType'] = messageType;
    data['messageContent'] = messageContent;
    data['messageObj'] = messageObj;
    data['signature'] = signature;
    data['sigType'] = sigType;
    data['link'] = link;
    data['timestamp'] = timestamp;
    data['encType'] = encType;
    data['encryptedSecret'] = encryptedSecret;
    data['deprecated'] = deprecated;
    data['deprecatedCode'] = deprecatedCode;
    return data;
  }
}

class MessageWithCID {
  String cid;
  String? chatId;
  String? link;
  String fromCAIP10;
  String toCAIP10;
  String fromDID;
  String toDID;
  String messageType;
  String messageContent;
  String signature;
  String sigType;
  int? timestamp;
  String encType;
  String encryptedSecret;
  String? verificationProof;

  MessageWithCID({
    required this.cid,
    this.chatId,
    this.link,
    required this.fromCAIP10,
    required this.toCAIP10,
    required this.fromDID,
    required this.toDID,
    required this.messageType,
    required this.messageContent,
    required this.signature,
    required this.sigType,
    this.timestamp,
    required this.encType,
    required this.encryptedSecret,
    this.verificationProof,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cid'] = cid;
    data['chatId'] = chatId;
    data['link'] = link;
    data['fromCAIP10'] = fromCAIP10;
    data['toCAIP10'] = toCAIP10;
    data['fromDID'] = fromDID;
    data['toDID'] = toDID;
    data['messageType'] = messageType;
    data['messageContent'] = messageContent;
    data['signature'] = signature;
    data['sigType'] = sigType;
    data['timestamp'] = timestamp;
    data['encType'] = encType;
    data['encryptedSecret'] = encryptedSecret;
    data['verificationProof'] = verificationProof;
    return data;
  }

  static MessageWithCID fromJson(Map<String, dynamic> json) {
    return MessageWithCID(
      cid: json['cid'],
      chatId: json['chatId'],
      link: json['link'],
      fromCAIP10: json['fromCAIP10'],
      toCAIP10: json['toCAIP10'],
      fromDID: json['fromDID'],
      toDID: json['toDID'],
      messageType: json['messageType'],
      messageContent: json['messageContent'],
      signature: json['signature'],
      sigType: json['sigType'],
      timestamp: json['timestamp'],
      encType: json['encType'],
      encryptedSecret: json['encryptedSecret'],
      verificationProof: json['verificationProof'],
    );
  }
}

class SendMessage {
  String type;
  String content;
  META_ACTION? action;
  Info? info;
  REACTION_TYPE? reactionAction;
  String? reference;

  SendMessage({
    required this.type,
    required this.content,
    this.action,
    this.info,
    this.reactionAction,
    this.reference,
  });

  factory SendMessage.fromMap(Map<String, dynamic> map) {
    final messageType = map['type'] as String;
    switch (messageType) {
      case MessageType.TEXT:
      case MessageType.IMAGE:
      case MessageType.FILE:
      case MessageType.MEDIA_EMBED:
      case MessageType.GIF:
        return SendMessage(
          type: messageType,
          content: map['content'] as String,
        );
      case MessageType.META:
        return SendMessage(
          type: messageType,
          content: map['content'] as String,
          action: map['action'] as META_ACTION,
          info: Info.fromJson(map['info']),
        );
      case MessageType.REACTION:
        return SendMessage(
          type: messageType,
          content: map['content'] as String,
          reactionAction: map['action'] as REACTION_TYPE,
          reference: map['reference'] as String?,
        );
      default:
        throw ArgumentError('Invalid message type: $messageType');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['content'] = content;

    if (type == MessageType.META) {
      data['action'] = action.toString();
      data['info'] = info?.toJson();
    }

    if (type == MessageType.REACTION) {
      data['reactionAction'] = reactionAction;
      data['reference'] = reference;
    }

    return data;
  }
}

class Info {
  List<String> affected;
  Map<String, dynamic> arbitrary;

  Info({
    required this.affected,
    required this.arbitrary,
  });

  factory Info.fromJson(Map<String, dynamic> map) {
    return Info(
      affected: List<String>.from(map['affected']),
      arbitrary: map['arbitrary'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['affected'] = affected;
    data['arbitrary'] = arbitrary;
    return data;
  }
}

class MetaMessage extends SendMessage {
  MetaMessage({
    required META_ACTION action,
    required Info info,
    required String content,
  }) : super(
            type: MessageType.META,
            content: content,
            action: action,
            info: info);

  factory MetaMessage.fromJson(Map<String, dynamic> json) {
    return MetaMessage(
      action: getMetaActionValue(json['action']),
      info: Info.fromJson(json['info']),
      content: json['content'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['action'] = action?.index;
    data['info'] = info?.toJson();
    data['content'] = content;
    return data;
  }
}

class ReactionMessage extends SendMessage {
  ReactionMessage({
    required REACTION_TYPE action,
    String? reference,
    required String content,
  }) : super(
            type: MessageType.REACTION,
            content: content,
            reactionAction: action,
            reference: reference);

  factory ReactionMessage.fromJson(Map<String, dynamic> json) {
    return ReactionMessage(
      action: json['action'] as REACTION_TYPE,
      reference: json['reference'] as String?,
      content: json['content'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['action'] = action;
    data['reference'] = reference;
    data['content'] = content;
    return data;
  }
}

/// Represents a message containing an image.
///
/// The image is represented by its data, name, and size.
class ImageMessage extends SendMessage {
  /// Creates a new instance of [ImageMessage].
  ///
  /// [content] is the actual data content of the image encoded in base64 format.
  ///
  /// [name] is the name of the image file.
  ///
  /// [size] is the size of the image file
  ImageMessage({
    required String content,
    String? name,
    String? size,
  }) : super(
          type: MessageType.IMAGE,
          content: jsonEncode({
            'content': content,
            'name': name,
            'size': size,
          }),
        );

  /// Creates a new instance of [ImageMessage] from a JSON map.
  ///
  /// [json] is the JSON map to create the instance from.
  factory ImageMessage.fromJson(Map<String, dynamic> json) {
    return ImageMessage(
      content: json['content'],
      name: json['name'],
      size: json['size'],
    );
  }
}

/// Represents a message containing a file.
///
/// The file is represented by its data, name, type, and size.
class FileMessage extends SendMessage {
  /// Creates a new instance of [FileMessage].
  ///
  /// [content] is the actual data content of the file encoded in base64 format.
  ///
  /// [name] is the name of the file.
  ///
  /// [type] is the MIME type or content type of the file (e.g., text/plain).
  ///
  /// [size] is the size of the file, represented as a string.
  FileMessage({
    required String content,
    String? name,
    String? type,
    String? size,
  }) : super(
          type: MessageType.FILE,
          content: jsonEncode({
            'content': content,
            'name': name,
            'type': type,
            'size': size,
          }),
        );

  /// Creates a new instance of [FileMessage] from a JSON map.
  ///
  /// [json] is the JSON map to create the instance from.
  factory FileMessage.fromJson(Map<String, dynamic> json) {
    return FileMessage(
      content: json['content'],
      name: json['name'],
      type: json['type'],
      size: json['size'],
    );
  }
}
