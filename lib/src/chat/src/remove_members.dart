import 'package:push_restapi_dart/push_restapi_dart.dart' as push;

import '../../../push_restapi_dart.dart';

Future<GroupDTO?> removeMembers({
  required String chatId,
  String? account,
  Signer? signer,
  String? pgpPrivateKey,
  required List<String> members,
}) async {
  try {
    if (account == null && signer == null) {
      throw Exception('At least one from account or signer is necessary!');
    }

    if (members.isEmpty) {
      throw Exception("Member address array cannot be empty!");
    }

    for (var member in members) {
      if (!isValidETHAddress(member)) {
        throw Exception('Invalid member address: $member');
      }
    }

    final group = await getGroup(chatId: chatId);

    if (group == null) {
      throw Exception('Group not found: $chatId');
    }

    List<String> convertedMembers =
        getMembersList(group.members, group.pendingMembers);

    List<String> membersToBeRemoved =
        members.map((member) => walletToPCAIP10(member)).toList();

    for (var member in membersToBeRemoved) {
      if (!convertedMembers.contains(member)) {
        throw Exception('Member $member not present in the list');
      }
    }

    convertedMembers = convertedMembers
        .where((member) => !membersToBeRemoved.contains(member))
        .toList();

    List<String> convertedAdmins =
        getAdminsList(group.members, group.pendingMembers);

    final updatedGroup = await push.updateGroup(
        chatId: chatId,
        groupName: group.groupName!,
        groupImage: group.groupImage!,
        groupDescription: group.groupDescription!,
        members: convertedMembers,
        admins: convertedAdmins,
        signer: signer,
        scheduleAt: group.scheduleAt,
        scheduleEnd: group.scheduleEnd,
        status: ChatStatus.ENDED,
        isPublic: group.isPublic);

    return updatedGroup;
  } catch (e) {
    log("[Push SDK] - API  - Error - API removeMembers -: $e ");
    rethrow;
  }
}
