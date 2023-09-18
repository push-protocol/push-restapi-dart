import 'package:push_restapi_dart/push_restapi_dart.dart' as push;

import '../../../push_restapi_dart.dart';

Future<GroupDTO?> removeAdmins({
  required String chatId,
  String? account,
  Signer? signer,
  String? pgpPrivateKey,
  required List<String> admins,
}) async {
  try {
    if (account == null && signer == null) {
      throw Exception('At least one from account or signer is necessary!');
    }

    if (admins.isEmpty) {
      throw Exception("Admin address array cannot be empty!");
    }

    for (var admin in admins) {
      if (!isValidETHAddress(admin)) {
        throw Exception('Invalid admin address: $admin');
      }
    }

    final group = await getGroup(chatId: chatId);

    if (group == null) {
      throw Exception('Group not found: $chatId');
    }

    List<String> convertedMembers =
        getMembersList(group.members, group.pendingMembers);

    List<String> adminsToBeRemoved =
        admins.map((admin) => walletToPCAIP10(admin)).toList();

    for (var admin in adminsToBeRemoved) {
      if (!convertedMembers.contains(admin)) {
        throw Exception('Member $admin not present in the list');
      }
    }

    List<String> convertedAdmins =
        getAdminsList(group.members, group.pendingMembers);

    for (var admin in adminsToBeRemoved) {
      if (!convertedAdmins.contains(admin)) {
        throw Exception('Admin $admin not present in the list');
      }
    }

    convertedMembers
        .removeWhere((member) => adminsToBeRemoved.contains(member));
    convertedAdmins.removeWhere((member) => adminsToBeRemoved.contains(member));

    final updatedGroup = await push.updateGroup(
        chatId: chatId,
        groupName: group.groupName!,
        groupImage: group.groupImage,
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
    log("[Push SDK] - API  - Error - API removeAdmins -: $e ");
    rethrow;
  }
}
