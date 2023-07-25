import '../../../push_restapi_dart.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart' as push;

Future<SpaceDTO?> start({
  String? account,
  Signer? signer,
  required String spaceId,
}) async {
  try {
    final space = await get(spaceId: spaceId);

    if (space.status != ChatStatus.PENDING) {
      throw Exception(
          'Unable to start the space as it is not in the pending state');
    }

    final convertedMembers =
        getSpacesMembersList(space.members, space.pendingMembers);
    final convertedAdmins =
        getSpaceAdminsList(space.members, space.pendingMembers);

    final group = await push.updateGroup(
        chatId: spaceId,
        groupName: space.spaceName,
        groupImage: space.spaceImage!,
        groupDescription: space.spaceDescription!,
        members: convertedMembers,
        admins: convertedAdmins,
        signer: signer,
        scheduleAt: space.scheduleAt,
        scheduleEnd: space.scheduleEnd,
        status: ChatStatus.ACTIVE,
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
