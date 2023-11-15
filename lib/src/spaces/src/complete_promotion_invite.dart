import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<void> completePromotionInvite_(
    {required SpaceData spaceData,
    required String inviteeAddress,
    required Set<String> pendingInvites}) async {
  isHost(
      hostAddress: spaceData.spaceCreator,
      errorMessage: "Only host is allowed to complete a promotion invite");

  // if the inviteeAddress is not present in _pendingInvites we throw exception
  if (!pendingInvites.contains(inviteeAddress)) {
    throw Exception("Invalid invite");
  }

  // elevate the listener to a speaker
  await addSpeakers(
      spaceId: spaceData.spaceId, speakers: [pCAIP10ToWallet(inviteeAddress)]);

  // fire a meta message signaling that the 'promoteeAddress' is now a speaker
  sendLiveSpaceData(
      messageType: MessageType.META,
      updatedLiveSpaceData: spaceData.liveSpaceData,
      content: CHAT.META_SPACE_SPEAKER_PRIVILEGE,
      affectedAddresses: [inviteeAddress],
      spaceId: spaceData.spaceId);

  pendingInvites.remove(inviteeAddress);
}
