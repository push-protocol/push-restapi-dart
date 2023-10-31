import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<void> completePromotionInvite_(
    {required LiveSpaceData liveSpaceData,
    required String spaceId,
    required String promoteeAddress}) async {
  // elevate the listener to a speaker
  await addSpeakers(
      spaceId: spaceId, speakers: [pCAIP10ToWallet(promoteeAddress)]);

  // fire a meta message signaling that the 'promoteeAddress' is now a speaker
  sendLiveSpaceData(
      messageType: MessageType.META,
      updatedLiveSpaceData: liveSpaceData,
      content: CHAT.META_SPACE_SPEAKER_PRIVILEGE,
      affectedAddresses: [promoteeAddress],
      spaceId: spaceId);
}
