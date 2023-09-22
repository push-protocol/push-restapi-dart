import '../../../push_restapi_dart.dart';

Future<SpaceData?> onReceiveMetaMessageForSpace(
  Map<String, dynamic> metaMessage,
  String spaceId,
) async {
  try {
    final latestSpace = await getSpaceById(spaceId: spaceId);

    MetaMessage parsedMetaMessage =
        MetaMessage.fromJson(metaMessage['messageObj']);

    return SpaceData.fromSpaceDTO(
        latestSpace, LiveSpaceData.fromJson(parsedMetaMessage.info!.arbitrary));
  } catch (e) {
    log('[Push SDK] - onReceiveMetaMessageForSpace  - Error-:  $e');
    rethrow;
  }
}
