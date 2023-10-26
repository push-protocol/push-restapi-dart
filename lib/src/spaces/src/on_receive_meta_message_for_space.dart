import '../../../push_restapi_dart.dart';

Future<SpaceData?> onReceiveMetaMessageForSpace({
  required Map<String, dynamic> message,
  required String spaceId,
}) async {
  try {
    final localAddress = getCachedWallet()!.address!;

    final latestSpace = await getSpaceById(spaceId: spaceId);

    MetaMessage parsedMetaMessage = MetaMessage.fromJson(message['messageObj']);

    if (parsedMetaMessage.type == MessageType.META &&
        parsedMetaMessage.content == CHAT.UA_LISTENER_REQUEST_MIC &&
        localAddress == parsedMetaMessage.info?.affected[0]) {
      // local address has been promoted to a speaker from a listener
      // TODO: Clear out the playbackURL and call join()
    }

    return SpaceData.fromSpaceDTO(
        latestSpace, LiveSpaceData.fromJson(parsedMetaMessage.info!.arbitrary));
  } catch (e) {
    log('[Push SDK] - onReceiveMetaMessageForSpace  - Error-:  $e');
    rethrow;
  }
}
