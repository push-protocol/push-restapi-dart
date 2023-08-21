import '../../../push_restapi_dart.dart';

Future initialize({
  required String spaceId,
}) async {
  try {
    final space = await getSpaceById(spaceId: spaceId);
    if (space.status == ChatStatus.ACTIVE) {
      
    }
  } catch (e) {
    print('[Push SDK] - API  - Error - API update -:  $e');
    rethrow;
  }
}
