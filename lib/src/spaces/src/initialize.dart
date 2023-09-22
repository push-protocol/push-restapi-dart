import '../../../push_restapi_dart.dart';

Future<SpaceData?> initializeSpace({
  required String spaceId,
}) async {
  try {
    final space = await getSpaceById(spaceId: spaceId);

    LiveSpaceData liveSpaceData = initLiveSpaceData;
    if (space.status == ChatStatus.ACTIVE) {
      liveSpaceData = await getLatestLiveSpaceData(spaceId: spaceId);
    }

    providerContainer.read(PushSpaceProvider.notifier).setData((oldData) {
      return SpaceData.fromSpaceDTO(space, liveSpaceData);
    });

    return SpaceData.fromSpaceDTO(space, liveSpaceData);
  } catch (e) {
    print('[Push SDK] - API - Error - API initialize -:  $e');
    rethrow;
  }
}
