import 'dart:convert';

import '../../../push_restapi_dart.dart';

Future<GroupDTO?> updateGroup(
    {required String chatId,
    String? account,
    Signer? signer,
    required String groupName,
    required String groupDescription,
    String? groupImage,
    required List<String> members,
    required List<String> admins,
    required bool isPublic,
    String? contractAddressNFT,
    int? numberOfNFTs,
    String? contractAddressERC20,
    int? numberOfERC20,
    String? pgpPrivateKey,
    String? meta,
    DateTime? scheduleAt,
    DateTime? scheduleEnd,
    ChatStatus? status}) async {
  try {
    account ??= getCachedWallet()?.address;
    signer ??= getCachedWallet()?.signer;
    pgpPrivateKey ??= getCachedWallet()?.pgpPrivateKey;

    if (account == null && signer == null) {
      throw Exception('At least one from account or signer is necessary!');
    }

    final wallet = getWallet(address: account, signer: signer);
    String userDID = getAccountAddress(wallet);

    updateGroupRequestValidator(
      chatId,
      groupName,
      groupDescription,
      groupImage,
      members,
      admins,
      userDID,
    );

    final connectedUser = await getConnectedUserV2(
      wallet: wallet,
      privateKey: pgpPrivateKey,
    );

    final convertedMembersDIDList =
        await Future.wait(members.map((item) => getUserDID(address: item)));
    final convertedAdminsDIDList =
        await Future.wait(admins.map((item) => getUserDID(address: item)));

    final bodyToBeHashed = {
      'groupName': groupName,
      'groupDescription': groupDescription,
      'groupImage': groupImage,
      'members': convertedMembersDIDList,
      'admins': convertedAdminsDIDList,
      'chatId': chatId,
    };

    final hash = generateHash(bodyToBeHashed);

    final publicKeyJSON = jsonDecode(connectedUser!.user.publicKey!);
    final signature = await sign(
      message: hash,
      privateKey: connectedUser.privateKey!,
      publicKey: publicKeyJSON["key"] ?? connectedUser.user.publicKey!,
    );

    final sigType = 'pgp';
    final verificationProof = '$sigType:$signature:$userDID';

    final body = {
      'groupName': groupName,
      'groupImage': groupImage,
      'groupDescription': groupDescription,
      'members': convertedMembersDIDList,
      'admins': convertedAdminsDIDList,
      'address': 'eip155:$userDID',
      'verificationProof': verificationProof,
      'scheduleAt': scheduleAt?.toIso8601String(),
      'scheduleEnd': scheduleEnd?.toIso8601String(),
      if (meta != null) 'meta': meta,
      if (status != null) 'status': chatStringFromChatStatus(status),
    };

    final result = await http.put(
      path: '/v1/chat/groups/$chatId',
      data: body,
    );

    if (result == null || result is String) {
      return null;
    }

    return GroupDTO.fromJson(result);
  } catch (e) {
    log("[Push SDK] - API  - Error - API updateGroup -: $e ");
    rethrow;
  }
}
