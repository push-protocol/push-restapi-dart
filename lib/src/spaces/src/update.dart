import '../../../push_restapi_dart.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart' as push;

Future<SpaceDTO?> updateSpace({
  String? account,
  Signer? signer,
  required String spaceId,
  required String spaceName,
  required String spaceDescription,
  String? spaceImage,
  required List<String> listeners,
  required List<String> speakers,
  String? pgpPrivateKey,
  String? meta,
  required DateTime scheduleAt,
  DateTime? scheduleEnd,
  required ChatStatus status,
}) async {
  try {
    final space = await getSpaceById(spaceId: spaceId);

    if (space.status == ChatStatus.ACTIVE) {
      throw Exception('Unable change the start date/time of an active space');
    }

    if (space.status == ChatStatus.ENDED && scheduleEnd != null) {
      throw Exception('Unable change the end date/time of an ended space');
    }

    final group = await push.updateGroup(
        chatId: spaceId,
        groupName: spaceName,
        groupImage: spaceImage,
        groupDescription: spaceDescription,
        members: listeners,
        admins: speakers,
        signer: signer,
        pgpPrivateKey: pgpPrivateKey,
        scheduleAt: scheduleAt,
        scheduleEnd: scheduleEnd,
        status: status,
        isPublic: space.isPublic);

    if (group != null) {
      return groupDtoToSpaceDto(group);
    } else {
      throw Exception('Error while updating Space : $spaceId');
    }
  } catch (e) {
    print('[Push SDK] - API  - Error - API update -:  $e');
    rethrow;
  }
}
