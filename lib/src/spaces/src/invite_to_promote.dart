import '../../../push_restapi_dart.dart';

/// This function is used to invite a listener to be promoted to a speaker role
inviteToPromote_(
    {required SpaceData spaceData,
    required String inviteeAddress,
    required SPACE_INVITE_ROLES role,
    required Set<String> pendingInvites}) {
  isHost(
      hostAddress: spaceData.spaceCreator,
      errorMessage:
          "Only host is allowed to invite a listener to become a speaker");

  // check is the caller is an active listener & modify listener data accordingly
  bool isActiveListener = false;
  for (int i = 0; i < spaceData.liveSpaceData.listeners.length; i++) {
    ListenerPeer listener = spaceData.liveSpaceData.listeners[i];
    if (listener.address == pCAIP10ToWallet(inviteeAddress)) {
      isActiveListener = true;
    }
  }

  if (!isActiveListener) {
    throw Exception("Invitee address is not an active listener");
  }

  // Add the invitee address to the pending invites set
  pendingInvites.add(inviteeAddress);

  // Fire a meta message to invite a listener address to become a speaker
  sendLiveSpaceData(
      messageType: MessageType.META,
      updatedLiveSpaceData: spaceData.liveSpaceData,
      content: CHAT.META_SPACE_LISTENER_PROMOTION_INVITE,
      affectedAddresses: [inviteeAddress],
      spaceId: spaceData.spaceId);
}
