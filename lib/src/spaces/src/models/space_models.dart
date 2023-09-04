import '../../../../push_restapi_dart.dart';

class Peer {
  String address = '';
  EmojiReaction? emojiReactions;
}

class EmojiReaction {
  String emoji = '';
  String expiresIn = '';
}

class ListenerPeer extends Peer {
  bool handRaised = false;
}

class AdminPeer extends Peer {
  bool? audio;
}

class LiveSpaceData {
  AdminPeer host = AdminPeer();
  List<AdminPeer> coHosts = [];
  List<AdminPeer> speakers = [];
  List<ListenerPeer> listeners = [];

  LiveSpaceData({
    required this.host,
    required this.coHosts,
    required this.speakers,
    required this.listeners,
  });
}

class SpaceData extends SpaceDTO {
  LiveSpaceData liveSpaceData = LiveSpaceData(
    host: AdminPeer(),
    coHosts: [],
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
