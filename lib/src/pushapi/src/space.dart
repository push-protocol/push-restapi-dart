// ignore_for_file: library_prefixes

import 'package:push_restapi_dart/src/pushapi/src/chat.dart';

import '../../../push_restapi_dart.dart';
import '../../spaces/space.dart' as PUSH_SPACE;
import '../../chat/chat.dart' as PUSH_CHAT;

class Space {
  late final Signer? _signer;
  late final ENV env;
  late final String _account;
  late final String? _decryptedPgpPvtKey;
  void Function(ProgressHookType)? progressHook;

  late final Chat chatInstance;
  late final GroupParticipantsAPI participants;

  Space({
    Signer? signer,
    required String account,
    String? decryptedPgpPvtKey,
    String? pgpPublicKey,
    required this.progressHook,
    required this.env,
  }) {
    _signer = signer;
    _account = account;
    _decryptedPgpPvtKey = decryptedPgpPvtKey;

    chatInstance = Chat(
        env: env,
        account: account,
        progressHook: progressHook,
        decryptedPgpPvtKey: _decryptedPgpPvtKey,
        pgpPublicKey: pgpPublicKey,
        signer: _signer);

    participants = GroupParticipantsAPI();
  }

  bool get _hasSigner => _signer != null;

  Future<SpaceInfoDTO?> create({
    required String name,
    required SpaceCreationOptions options,
  }) async {
    return PUSH_SPACE.createSpaceV2(
      signer: _signer,
      pgpPrivateKey: _decryptedPgpPvtKey,
      spaceName: name,
      spaceDescription: options.description,
      listeners: options.participants.listeners,
      speakers: options.participants.speakers,
      spaceImage: options.image,
      isPublic: !options.private,
      rules: options.rules,
      scheduleAt: options.schedule.start,
      scheduleEnd: options.schedule.end,
      account: _account,
    );
  }

  Future<SpaceInfoDTO?> update({
    required String spaceId,
    required SpaceUpdateOptions options,
  }) async {
    if (!_hasSigner) {
      throw Exception(PushAPI.ensureSignerMessage());
    }

    GroupInfoDTO? group;

    try {
      group = await PUSH_CHAT.getGroupInfo(chatId: spaceId);
    } catch (e) {
      throw Exception('Space not found');
    }
    final updateGroupProfileOptions = ChatUpdateGroupProfileType(
      chatId: spaceId,
      groupName: options.name ?? group.groupName,
      groupDescription: options.description ?? group.groupDescription,
      groupImage: options.image ?? group.groupImage,
      rules: options.rules ?? group.rules,
      account: _account,
      pgpPrivateKey: _decryptedPgpPvtKey,
    );

    final updateGroupConfigOptions = ChatUpdateConfigProfileType(
      chatId: spaceId,
      meta: options.meta ?? group.meta,
      scheduleAt: options.scheduleAt ?? group.scheduleAt,
      scheduleEnd: options.scheduleEnd ?? group.scheduleEnd,
      status: options.status ?? group.status,
      account: _account,
      pgpPrivateKey: _decryptedPgpPvtKey,
    );

    await PUSH_CHAT.updateGroupProfile(options: updateGroupProfileOptions);
    final result =
        await PUSH_CHAT.updateGroupConfig(options: updateGroupConfigOptions);

    return result.toSpaceInfo;
  }

  Future<SpaceInfoDTO> info({required String spaceId}) async {
    final result = await PUSH_CHAT.getGroupInfo(chatId: spaceId);
    return result.toSpaceInfo;
  }

  Future<SpaceAccess> permissions({required String spaceId}) async {
    final result =
        await PUSH_CHAT.getGroupAccess(chatId: spaceId, did: _account);

    return SpaceAccess.fromJson(result.toJson());
  }

  Future<SpaceInfoDTO?> add({
    required String spaceId,
    required SpaceRoles role,
    required List<String> accounts,
  }) async {
    if (!_hasSigner) {
      throw Exception(PushAPI.ensureSignerMessage());
    }

    if (accounts.isEmpty) {
      throw Exception('accounts array cannot be empty!');
    }

    for (var account in accounts) {
      if (!isValidETHAddress(account)) {
        throw Exception('Invalid account address: $account');
      }
    }

    if (role == SpaceRoles.SPEAKERS) {
      return (await PUSH_CHAT.addAdmins(
        chatId: spaceId,
        admins: accounts,
        account: _account,
        pgpPrivateKey: _decryptedPgpPvtKey,
        signer: _signer,
      ))
          .toSpaceInfo;
    } else {
      return (await PUSH_CHAT.addMembers(
        chatId: spaceId,
        members: accounts,
        account: _account,
        pgpPrivateKey: _decryptedPgpPvtKey,
        signer: _signer,
      ))
          .toSpaceInfo;
    }
  }

  Future<SpaceInfoDTO> remove({
    required String spaceId,
    required SpaceRoles role,
    required List<String> accounts,
  }) async {
    if (!_hasSigner) {
      throw Exception(PushAPI.ensureSignerMessage());
    }

    if (accounts.isEmpty) {
      throw Exception('accounts array cannot be empty!');
    }

    for (var account in accounts) {
      if (!isValidETHAddress(account)) {
        throw Exception('Invalid account address: $account');
      }
    }

    var adminsToRemove = <String>[];
    var membersToRemove = <String>[];

    for (var account in accounts) {
      final status =
          await PUSH_CHAT.getGroupMemberStatus(chatId: spaceId, did: account);
      if (status.isAdmin) {
        adminsToRemove.add(account);
      } else {
        membersToRemove.add(account);
      }
    }

    if (adminsToRemove.isNotEmpty) {
      await PUSH_CHAT.removeAdmins(
        chatId: spaceId,
        admins: adminsToRemove,
        account: _account,
        pgpPrivateKey: _decryptedPgpPvtKey,
        signer: _signer,
      );
    }

    if (membersToRemove.isNotEmpty) {
      await PUSH_CHAT.removeMembers(
        chatId: spaceId,
        members: membersToRemove,
        account: _account,
        pgpPrivateKey: _decryptedPgpPvtKey,
        signer: _signer,
      );
    }

    return info(spaceId: spaceId);
  }

  Future<SpaceInfoDTO?> modify({
    required String spaceId,
    required SpaceRoles role,
    required List<String> accounts,
  }) async {
    if (!_hasSigner) {
      throw Exception(PushAPI.ensureSignerMessage());
    }

    if (accounts.isEmpty) {
      throw Exception('accounts array cannot be empty!');
    }

    for (var account in accounts) {
      if (!isValidETHAddress(account)) {
        throw Exception('Invalid account address: $account');
      }
    }

    return (await PUSH_CHAT.modifyRoles(
      options: ModifyRolesType(
        chatId: spaceId,
        newRole: role.toGroupValue,
        account: _account,
        members: accounts,
        pgpPrivateKey: _decryptedPgpPvtKey,
        signer: _signer,
      ),
    ))
        .toSpaceInfo;
  }

  Future<SpaceInfoDTO> join({required String spaceId}) async {
    if (!_hasSigner) {
      throw Exception(PushAPI.ensureSignerMessage());
    }

    final status = await PUSH_CHAT.getGroupMemberStatus(
      chatId: spaceId,
      did: _account,
    );

    if (status.isPending) {
      await PUSH_CHAT.approve(
        senderAddress: spaceId,
        account: _account,
        pgpPrivateKey: _decryptedPgpPvtKey,
        signer: _signer,
      );
    } else if (!status.isMember) {
      await PUSH_CHAT.addMembers(
        chatId: spaceId,
        members: [_account],
        account: _account,
        pgpPrivateKey: _decryptedPgpPvtKey,
        signer: _signer,
      );
    }

    return await info(spaceId: spaceId);
  }

  Future<SpaceInfoDTO> leave({required String spaceId}) async {
    if (!_hasSigner) {
      throw Exception(PushAPI.ensureSignerMessage());
    }

    // chatInstance.group.leave(target: spaceId);

    final status = await PUSH_CHAT.getGroupMemberStatus(
      chatId: spaceId,
      did: _account,
    );

    if (status.isAdmin) {
      await PUSH_CHAT.removeAdmins(
        chatId: spaceId,
        admins: [_account],
        account: _account,
        pgpPrivateKey: _decryptedPgpPvtKey,
        signer: _signer,
      );
    } else if (!status.isMember) {
      await PUSH_CHAT.removeMembers(
        chatId: spaceId,
        members: [_account],
        account: _account,
        pgpPrivateKey: _decryptedPgpPvtKey,
        signer: _signer,
      );
    }

    return await info(spaceId: spaceId);
  }

  Future<List<SpaceInfoDTO>> search({
    required String term,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await PUSH_SPACE.searchSpaces(
      searchTerm: term,
      pageNumber: page,
      pageSize: limit,
    );

    return response.map((e) => e.toSpaceInfo).toList();
  }

  Future<List<SpaceFeeds>?> trending({
    required String term,
    int page = 1,
    int limit = 20,
  }) async {
    return await PUSH_SPACE.trending(page: page, limit: limit);
  }

  Future<List<SpaceFeeds>?> list({
    required SpaceListType type,
    int page = 1,
    int limit = 20,
    String? overrideAccount,
  }) {
    return PUSH_SPACE.spaces(
      accountAddress: _account,
      limit: limit,
      page: page,
      pgpPrivateKey: _decryptedPgpPvtKey,
      toDecrypt: _hasSigner,
    );
  }

  Future<String?> accept({required String spaceId}) async {
    if (!_hasSigner) {
      throw Exception(PushAPI.ensureSignerMessage());
    }

    return chatInstance.accept(target: spaceId);
  }

  Future<String?> reject({required String spaceId}) async {
    if (!_hasSigner) {
      throw Exception(PushAPI.ensureSignerMessage());
    }

    return chatInstance.reject(target: spaceId);
  }
}
