import '../../../push_restapi_dart.dart';

Future<SpaceData> acceptPromotionRequest_(
    {required SpaceData data, required String promoteeAddress}) async {
  isHost(
      hostAddress: data.spaceCreator,
      errorMessage: "Only host is allowed to accept a promotion request");

  // elevate the listener to a speaker
  await addSpeakers(
      spaceId: data.spaceId, speakers: [pCAIP10ToWallet(promoteeAddress)]);

  data = setHandRaisedForListener(
      handRaised: false, listenerAddress: promoteeAddress, spaceData: data);

  // fire a meta message signaling that the 'affectedAddress' is now promoted
  sendLiveSpaceData(
      messageType: MessageType.META,
      updatedLiveSpaceData: data.liveSpaceData,
      content: CHAT.META_SPACE_SPEAKER_PRIVILEGE,
      affectedAddresses: [promoteeAddress],
      spaceId: data.spaceId);

  return data;
}
