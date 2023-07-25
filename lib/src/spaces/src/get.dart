import '../../../push_restapi_dart.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart' as push;

Future<SpaceDTO> get({
  required String spaceId,
}) async {
  try {
    final group = await push.getGroup(chatId: spaceId);
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
