import '../../../push_restapi_dart.dart';

/// This function is used to invite a listener to be promoted to a speaker role
inviteToPromote_(
    {required LiveSpaceData liveSpaceData,
    required String spaceId,
    required String inviteeAddress,
    required SPACE_INVITE_ROLES role}) async {
  // Fire a meta message to invite a listener address to become a speaker
  sendLiveSpaceData(
      messageType: MessageType.META,
      updatedLiveSpaceData: liveSpaceData,
      content: CHAT.META_SPACE_LISTENER_PROMOTION_INVITE,
      affectedAddresses: [inviteeAddress],
      spaceId: spaceId);
}
