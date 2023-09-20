import '../../../../push_restapi_dart.dart';

class EmojiReaction {
  String emoji = '';
  String expiresIn = '';

  EmojiReaction({
    this.emoji = '',
    this.expiresIn = '',
  });

  factory EmojiReaction.fromJson(Map<String, dynamic> map) {
    return EmojiReaction(
      emoji: map['emoji'] ?? '',
      expiresIn: map['expiresIn'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'expiresIn': expiresIn,
    };
  }
}

class Peer {
  String address = '';
  EmojiReaction? emojiReactions;

  Peer({
    this.address = '',
    this.emojiReactions,
  });

  factory Peer.fromJson(Map<String, dynamic> map) {
    return Peer(
      address: map['address'] ?? '',
      emojiReactions: map['emojiReactions'] != null
          ? EmojiReaction.fromJson(map['emojiReactions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'emojiReactions': emojiReactions?.toJson(),
    };
  }
}

class ListenerPeer extends Peer {
  bool handRaised = false;

  ListenerPeer({
    String address = '',
    EmojiReaction? emojiReactions,
    this.handRaised = false,
  }) : super(
          address: address,
          emojiReactions: emojiReactions,
        );

  factory ListenerPeer.fromJson(Map<String, dynamic> map) {
    return ListenerPeer(
      address: map['address'] ?? '',
      emojiReactions: map['emojiReactions'] != null
          ? EmojiReaction.fromJson(map['emojiReactions'])
          : null,
      handRaised: map['handRaised'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'handRaised': handRaised,
    };
  }
}

class AdminPeer extends Peer {
  bool? audio;

  AdminPeer({
    String address = '',
    EmojiReaction? emojiReactions,
    this.audio,
  }) : super(
          address: address,
          emojiReactions: emojiReactions,
        );

  factory AdminPeer.fromJson(Map<String, dynamic> map) {
    return AdminPeer(
      address: map['address'] ?? '',
      emojiReactions: map['emojiReactions'] != null
          ? EmojiReaction.fromJson(map['emojiReactions'])
          : null,
      audio: map['audio'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'audio': audio,
    };
  }
}

class LiveSpaceData {
  AdminPeer host = AdminPeer();
  // List<AdminPeer> coHosts = [];
  List<AdminPeer> speakers = [];
  List<ListenerPeer> listeners = [];

  LiveSpaceData({
    required this.host,
    // required this.coHosts,
    required this.speakers,
    required this.listeners,
  });

  factory LiveSpaceData.fromJson(Map<String, dynamic> map) {
    return LiveSpaceData(
      host: AdminPeer.fromJson(map['host']),
      // coHosts: (map['coHosts'] as List<dynamic>)
      //     .map((adminPeer) => AdminPeer.fromJson(adminPeer))
      //     .toList(),
      speakers: (map['speakers'] as List<dynamic>)
          .map((adminPeer) => AdminPeer.fromJson(adminPeer))
          .toList(),
      listeners: (map['listeners'] as List<dynamic>)
          .map((listenerPeer) => ListenerPeer.fromJson(listenerPeer))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'host': host.toJson(),
      // 'coHosts': coHosts.map((adminPeer) => adminPeer.toJson()).toList(),
      'speakers': speakers.map((adminPeer) => adminPeer.toJson()).toList(),
      'listeners':
          listeners.map((listenerPeer) => listenerPeer.toJson()).toList(),
    };
  }
}

class SpaceData extends SpaceDTO {
  LiveSpaceData liveSpaceData = LiveSpaceData(
    host: AdminPeer(),
    // coHosts: [],
    speakers: [],
    listeners: [],
  );

  SpaceData({
    required List<SpaceMemberDTO> members,
    required List<SpaceMemberDTO> pendingMembers,
    String? contractAddressERC20,
    required int numberOfERC20,
    String? contractAddressNFT,
    required int numberOfNFTTokens,
    required String verificationProof,
    String? spaceImage,
    required String spaceName,
    required bool isPublic,
    required String spaceDescription,
    required String spaceCreator,
    required String spaceId,
    DateTime? scheduleAt,
    DateTime? scheduleEnd,
    ChatStatus? status,
    required LiveSpaceData liveSpaceData,
  }) : super(
          members: members,
          pendingMembers: pendingMembers,
          contractAddressERC20: contractAddressERC20,
          numberOfERC20: numberOfERC20,
          contractAddressNFT: contractAddressNFT,
          numberOfNFTTokens: numberOfNFTTokens,
          verificationProof: verificationProof,
          spaceImage: spaceImage,
          spaceName: spaceName,
          isPublic: isPublic,
          spaceDescription: spaceDescription,
          spaceCreator: spaceCreator,
          spaceId: spaceId,
          scheduleAt: scheduleAt,
          scheduleEnd: scheduleEnd,
          status: status,
        ) {
    this.liveSpaceData = initLiveSpaceData;
  }

  static SpaceData fromSpaceDTO(
      SpaceDTO spaceDTO, LiveSpaceData liveSpaceData) {
    return SpaceData(
      members: spaceDTO.members,
      pendingMembers: spaceDTO.pendingMembers,
      contractAddressERC20: spaceDTO.contractAddressERC20,
      numberOfERC20: spaceDTO.numberOfERC20,
      contractAddressNFT: spaceDTO.contractAddressNFT,
      numberOfNFTTokens: spaceDTO.numberOfNFTTokens,
      verificationProof: spaceDTO.verificationProof,
      spaceImage: spaceDTO.spaceImage,
      spaceName: spaceDTO.spaceName,
      isPublic: spaceDTO.isPublic,
      spaceDescription: spaceDTO.spaceDescription ?? '',
      spaceCreator: spaceDTO.spaceCreator,
      spaceId: spaceDTO.spaceId,
      scheduleAt: spaceDTO.scheduleAt,
      scheduleEnd: spaceDTO.scheduleEnd,
      status: spaceDTO.status,
      liveSpaceData: liveSpaceData,
    );
  }
}
