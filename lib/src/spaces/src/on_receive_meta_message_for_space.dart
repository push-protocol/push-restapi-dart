import '../../../push_restapi_dart.dart';

Future<SpaceData?> onReceiveMetaMessageForSpace(
    {required Map<String, dynamic> message,
    required String spaceId,
    required Function() joinOnPromotion}) async {
  try {
    final localAddress = getCachedWallet()!.address!;

    final latestSpace = await getSpaceById(spaceId: spaceId);

    MetaMessage parsedMetaMessage = MetaMessage.fromJson(message['messageObj']);

    // local address has been promoted to a speaker from a listener
    if (parsedMetaMessage.type == MessageType.META &&
        parsedMetaMessage.content ==
            CHAT.META_SPACE_LISTENER_PROMOTION_ACCEPT &&
        localAddress == parsedMetaMessage.info?.affected[0]) {
      // join the room as a speaker
      joinOnPromotion();

      // dont update the space data on the class here, instead joinOnPromotion will handle it
      return null;
    }

    return SpaceData.fromSpaceDTO(
        latestSpace, LiveSpaceData.fromJson(parsedMetaMessage.info!.arbitrary));
  } catch (e) {
    log('[Push SDK] - onReceiveMetaMessageForSpace  - Error-:  $e');
    rethrow;
  }
}
