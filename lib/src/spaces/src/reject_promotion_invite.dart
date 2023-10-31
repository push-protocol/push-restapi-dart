import 'package:push_restapi_dart/push_restapi_dart.dart';

// This function rejects a promotion invite for a listener to become a speaker in a live space
rejectPromotionInvite_(
    {required LiveSpaceData liveSpaceData, required String spaceId}) {
  // Get the local address from the cached wallet
  final localAddress = getCachedWallet()?.address;

  // Fire a user activity message to reject the invite as a listener address to become a speaker
  sendLiveSpaceData(
      messageType: MessageType.USER_ACTIVITY,
      updatedLiveSpaceData: liveSpaceData,
      content: CHAT.UA_LISTENER_REJECT_PROMOTION,
      affectedAddresses: [localAddress!],
      spaceId: spaceId);
}