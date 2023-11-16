import 'package:push_restapi_dart/push_restapi_dart.dart';

// This function accepts a promotion invite for a listener to become a speaker in a live space
Future acceptPromotionInvite_({required SpaceData spaceData}) async {
  // Get the local address from the cached wallet
  final localAddress = getCachedWallet()?.address;

  // Fire a user activity message to accept the invite as a listener address to become a speaker
  await sendLiveSpaceData(
      messageType: MessageType.USER_ACTIVITY,
      updatedLiveSpaceData: spaceData.liveSpaceData,
      content: CHAT.UA_LISTENER_ACCEPT_PROMOTION,
      affectedAddresses: [localAddress!],
      spaceId: spaceData.spaceId);
}
