import '../../../push_restapi_dart.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart' as push;

Future<SpaceDTO?> stopSpace({
  String? accountAddress,
  Signer? signer,
  required String spaceId,
}) async {
  try {
    accountAddress ??= getCachedWallet()?.address;
    signer ??= getCachedWallet()?.signer;

    final space = await getSpace(spaceId: spaceId);

    if (space.status != ChatStatus.ENDED) {
      throw Exception('Space already ended');
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
        status: ChatStatus.ENDED,
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
