import 'package:push_restapi_dart/push_restapi_dart.dart' as push;

import '../../../push_restapi_dart.dart';

Future<GroupDTO?> addAdmins({
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

    List<String> adminsToBeAdded =
        admins.map((admin) => walletToPCAIP10(admin)).toList();

    for (var admin in adminsToBeAdded) {
      if (!convertedMembers.contains(admin)) {
        convertedMembers.add(admin);
      }
    }

    List<String> convertedAdmins =
        getAdminsList(group.members, group.pendingMembers);

    for (var admin in adminsToBeAdded) {
      if (convertedAdmins.contains(admin)) {
        throw Exception('Admin $admin already exists in the list');
      }
    }

    convertedAdmins.addAll(adminsToBeAdded);

    final updatedGroup = await push.updateGroup(
        chatId: chatId,
        groupName: group.groupName,
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
    log("[Push SDK] - API  - Error - API addAdmins -: $e ");
    rethrow;
  }
}
