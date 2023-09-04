import '../../../push_restapi_dart.dart';

Future<SpaceData?> initializeSpace({
  required String spaceId,
}) async {
  try {
    final space = await getSpaceById(spaceId: spaceId);

    var data = providerContainer.read(PushSpaceProvider).data;
    var liveSpaceData = data.liveSpaceData;
    if (space.status == ChatStatus.ACTIVE) {
      // TODO: call getLiveSpaceData
    }

    providerContainer.read(PushSpaceProvider.notifier).setData((oldData) {
      return SpaceData.fromSpaceDTO(space, liveSpaceData);
    });
    return SpaceData.fromSpaceDTO(space, liveSpaceData);
  } catch (e) {
    print('[Push SDK] - API  - Error - API initialize -:  $e');
    rethrow;
  }
}
