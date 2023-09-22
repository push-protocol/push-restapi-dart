import '../../../push_restapi_dart.dart';

Future<MetaMessage> onReceiveMetaMessageForSpace(Map<String, dynamic> metaMessage) async {
  final oldSpaceData = providerContainer.read(PushSpaceProvider).data;

  final latestSpace = await getSpaceById(spaceId: oldSpaceData.spaceId);
  MetaMessage parsedMetaMessage = MetaMessage.fromJson(metaMessage);
  final updatedSpaceData = SpaceData.fromSpaceDTO(
      latestSpace, LiveSpaceData.fromJson(parsedMetaMessage.info!.arbitrary));

  // TODO: Add the message queue here

  log('onReceiveMetaMessageForSpace - updatedSpaceData $updatedSpaceData');

  providerContainer.read(PushSpaceProvider.notifier).setData((oldData) {
    return updatedSpaceData;
  });

  return parsedMetaMessage;
}
