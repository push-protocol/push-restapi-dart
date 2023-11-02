import '../../../push_restapi_dart.dart';

SpaceData rejectPromotionRequest_(
    {required SpaceData data, required String promoteeAddress}) {
  isHost(
      hostAddress: data.spaceCreator,
      errorMessage: "Only host is allowed to reject a promotion request");

  data = setHandRaisedForListener(
      handRaised: false, listenerAddress: promoteeAddress, spaceData: data);

  // fire a meta message signaling that the 'affectedAddress' is not promoted
  sendLiveSpaceData(
      messageType: MessageType.META,
      updatedLiveSpaceData: data.liveSpaceData,
      content: CHAT.META_SPACE_LISTENER_PROMOTION_REJECT,
      affectedAddresses: [promoteeAddress],
      spaceId: data.spaceId);

  return data;
}
