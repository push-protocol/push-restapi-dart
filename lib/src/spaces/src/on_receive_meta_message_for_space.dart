import '../../../push_restapi_dart.dart';

Future<SpaceData?> onReceiveMetaMessage_(
    {required Map<String, dynamic> message,
    required String spaceId,
    required Function() handleJoinOnPromotion,
    required Function({required String inviteeAddress})
        handleCompletePromotionInvite,
    required Function({required String inviteeAddress})
        handleRemovePromotionInvite}) async {
  try {
    final localAddress = getCachedWallet()!.address!;

    final latestSpace = await getSpaceById(spaceId: spaceId);

    String messageType = message['messageType'];
    final parsedMetaMessage = messageType == MessageType.META
        ? MetaMessage.fromJson(message['messageObj'])
        : UserActivityMessage.fromJson(message['messageObj']);

    // local address has been promoted to a speaker from a listener
    if (messageType == MessageType.META &&
        parsedMetaMessage.content == CHAT.META_SPACE_SPEAKER_PRIVILEGE &&
        localAddress == parsedMetaMessage.info?.affected[0]) {
      // join the room as a speaker
      handleJoinOnPromotion();

      // dont update the space data on the class here, instead joinOnPromotion will handle it
      return null;
    }

    // listener address has accepted a promotion request
    if (messageType == MessageType.USER_ACTIVITY &&
        parsedMetaMessage.content == CHAT.UA_LISTENER_ACCEPT_PROMOTION_INVITE &&
        localAddress == pCAIP10ToWallet(latestSpace.spaceCreator)) {
      handleCompletePromotionInvite(
          inviteeAddress: parsedMetaMessage.info!.affected[0]);
    }

    // listener address has rejected a promotion request
    if (messageType == MessageType.USER_ACTIVITY &&
        parsedMetaMessage.content == CHAT.UA_LISTENER_REJECT_PROMOTION_INVITE &&
        localAddress == pCAIP10ToWallet(latestSpace.spaceCreator)) {
      handleRemovePromotionInvite(
          inviteeAddress: parsedMetaMessage.info!.affected[0]);
    }

    return SpaceData.fromSpaceDTO(
        latestSpace, LiveSpaceData.fromJson(parsedMetaMessage.info!.arbitrary));
  } catch (e) {
    log('[Push SDK] - onReceiveMetaMessageForSpace  - Error-:  $e');
    rethrow;
  }
}
