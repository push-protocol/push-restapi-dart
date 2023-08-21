// ignore_for_file: constant_identifier_names
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import '../../../../push_restapi_dart.dart';

class Meta {
  final String? chatId;
  final Initiator? initiator;
  final Broadcast? broadcast;

  Meta({
    this.chatId = '',
    this.initiator,
    this.broadcast,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      chatId: json['chatId'],
      initiator: Initiator.fromJson(json['initiator']),
      broadcast: json.containsKey('broadcast')
          ? Broadcast.fromJson(json['broadcast'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'initiator': initiator?.toJson(),
      if (broadcast != null) 'broadcast': broadcast!.toJson(),
    };
  }
}

class Initiator {
  final String? address;
  final dynamic signal;

  Initiator({
    this.address,
    this.signal,
  });

  factory Initiator.fromJson(Map<String, dynamic> json) {
    return Initiator(
      address: json['address'],
      signal: json['signal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'signal': signal,
    };
  }
}

class Broadcast {
  final dynamic livepeerInfo;
  final String? hostAddress;
  final String? coHostAddress;

  Broadcast({
    this.livepeerInfo,
    this.hostAddress,
    this.coHostAddress,
  });

  factory Broadcast.fromJson(Map<String, dynamic> json) {
    return Broadcast(
      livepeerInfo: json['livepeerInfo'],
      hostAddress: json['hostAddress'],
      coHostAddress: json['coHostAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'livepeerInfo': livepeerInfo,
      'hostAddress': hostAddress,
      if (coHostAddress != null) 'coHostAddress': coHostAddress,
    };
  }
}

class VideoCallData {
  final Meta? meta;
  final Local? local;
  final List<PeerData> incoming;

  VideoCallData({
    this.meta,
    this.local,
    this.incoming = const [],
  });

  factory VideoCallData.fromJson(Map<String, dynamic> json) {
    return VideoCallData(
      meta: Meta.fromJson(json['meta']),
      local: Local.fromJson(json['local']),
      incoming: List<PeerData>.from(
        json['incoming'].map((peerData) => PeerData.fromJson(peerData)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta?.toJson(),
      'local': local?.toJson(),
      'incoming': incoming.map((peerData) => peerData.toJson()).toList(),
    };
  }
}

class Local {
  final webrtc.MediaStream? stream;
  final bool? audio;
  final bool? video;
  final String address;

  Local({
    required this.stream,
    this.audio,
    this.video,
    required this.address,
  });

  factory Local.fromJson(Map<String, dynamic> json) {
    return Local(
      stream: json['stream'],
      audio: json['audio'],
      video: json['video'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stream': stream,
      'audio': audio,
      'video': video,
      'address': address,
    };
  }
}

class VideoCallInitiator {
  late String address;
  late dynamic signal;
}

class VideoCallBroadcast {
  late dynamic livepeerInfo;
  late String hostAddress;
  late String coHostAddress;
}

class VideoCallLocal {
  MediaStream? stream;
  String? audio;
  String? video;
  late String address;
}

class VideoCallIncoming {
  MediaStream? stream;
  String? audio;
  String? video;
  late String address;
  late Object status; //MediaStream
  late int retryCount;
}

class MediaStream {
  dynamic stream;
  String? audio;
  String? video;
  String? address;
  Object? status; //MediaStream
  int? retryCount;

  MediaStream({
    this.stream,
    this.audio,
    this.video,
    this.address,
    this.status,
    this.retryCount,
  });

  factory MediaStream.fromJson(Map<String, dynamic> json) {
    return MediaStream(
      stream: json.containsKey('stream')
          ? MediaStream.fromJson(json['stream'])
          : null,
      audio: json['audio'],
      video: json['video'],
      address: json['address'],
      status: json['status'],
      retryCount: json['retryCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stream': stream?.toJson(),
      'audio': audio,
      'video': video,
      'address': address,
      'status': status,
      'retryCount': retryCount,
    };
  }
}

class VideoCreateInputOptions {
  final bool video;
  final bool audio;
  final webrtc.MediaStream? stream;

  VideoCreateInputOptions({
    this.video = true,
    this.audio = true,
    this.stream,
  });
}

class VideoRequestInputOptions {
  late String senderAddress;
  late String recipientAddress;
  late String chatId;
  void Function(String)? onReceiveMessage;
  bool? retry;
}

class VideoAcceptRequestInputOptions {
  late dynamic signalData;
  late String senderAddress;
  late String recipientAddress;
  late String chatId;
  void Function(String)? onReceiveMessage;
  bool? retry;
}

class PeerData {
  final MediaStream stream; // You need to define IMediaStream accordingly
  final bool? audio;
  final bool? video;
  final String address;
  final VideoCallStatus status;
  final int retryCount;

  PeerData({
    required this.stream,
    this.audio,
    this.video,
    required this.address,
    required this.status,
    required this.retryCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'stream': stream.toJson(),
      'audio': audio,
      'video': video,
      'address': address,
      'status': status.toString(),
      'retryCount': retryCount,
    };
  }

  factory PeerData.fromJson(Map<String, dynamic> json) {
    return PeerData(
      stream: MediaStream.fromJson(json['stream']), // Update accordingly
      audio: json['audio'],
      video: json['video'],
      address: json['address'],
      status: _parseVideoCallStatus(json['status']),
      retryCount: json['retryCount'],
    );
  }

  static VideoCallStatus _parseVideoCallStatus(String status) {
    // Implement parsing logic here based on the string value
    switch (status) {
      case 'UNINITIALIZED':
        return VideoCallStatus.UNINITIALIZED;
      case 'INITIALIZED':
        return VideoCallStatus.INITIALIZED;
      case 'RECEIVED':
        return VideoCallStatus.RECEIVED;
      case 'CONNECTED':
        return VideoCallStatus.CONNECTED;
      case 'DISCONNECTED':
        return VideoCallStatus.DISCONNECTED;
      case 'RETRY_INITIALIZED':
        return VideoCallStatus.RETRY_INITIALIZED;
      case 'RETRY_RECEIVED':
        return VideoCallStatus.RETRY_RECEIVED;
      default:
        throw Exception('Unknown VideoCallStatus: $status');
    }
  }
}

enum VideoCallStatus {
  UNINITIALIZED,
  INITIALIZED,
  RECEIVED,
  CONNECTED,
  DISCONNECTED,
  RETRY_INITIALIZED,
  RETRY_RECEIVED,
}

class VideoCallInfoType {
  final String recipientAddress;
  final String senderAddress;
  final String chatId;
  final dynamic signalData;
  final VideoCallStatus status;
  final ENV? env;
  final int? callType; //VideoCallType
  final CallDetailsType? callDetails;

  VideoCallInfoType({
    required this.recipientAddress,
    required this.senderAddress,
    required this.chatId,
    required this.signalData,
    required this.status,
    this.env,
    this.callType,
    this.callDetails,
  }) {
    assert(VideoCallType.isValidVideoCallType(callType));
  }
}

class UserInfoType {
  final Signer signer;
  final int chainId;
  final String pgpPrivateKey;

  UserInfoType({
    required this.signer,
    required this.chainId,
    required this.pgpPrivateKey,
  });
}

class VideoDataType {
  final String recipientAddress;
  final String senderAddress;
  final String chatId;
  final dynamic signalData;
  final VideoCallStatus status;
  final CallDetailsType? callDetails;

  VideoDataType({
    required this.recipientAddress,
    required this.senderAddress,
    required this.chatId,
    this.signalData,
    required this.status,
    this.callDetails,
  });
}

class CallDetailsType {
  final dynamic type; // You can replace dynamic with the appropriate enum type
  final Map<String, dynamic> data;

  CallDetailsType({
    required this.type,
    required this.data,
  });
}

class VideoCallType {
  static const PUSH_VIDEO = 1;
  static const PUSH_SPACE = 2;

  static bool isValidVideoCallType(int? type) {
    return [PUSH_SPACE, PUSH_VIDEO].contains(type);
  }
}
