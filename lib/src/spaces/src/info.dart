import '../../../push_restapi_dart.dart';

Future<SpaceDTO> info({
  required String spaceId,
}) async {
  try {
    if (spaceId.isEmpty) {
      throw Exception("spaceId cannot be null or empty");
    }
    final group = await getGroup(chatId: spaceId);
    if (group != null) {
      return groupDtoToSpaceDto(group);
    } else {
      throw Exception('Space not found for id : $spaceId');
    }
  } catch (e) {
    print('[Push SDK] - API  - Error - API update -:  $e');
    rethrow;
  }
}
