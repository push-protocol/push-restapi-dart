// ignore_for_file: library_prefixes

import '../../push_restapi_dart.dart';
import '../chat/chat.dart' as PUSH_CHAT;
import '../user/user.dart' as PUSH_USER;

class Chat {
  late final Signer? _signer;

  late final String _account;
  late final String? _decryptedPgpPvtKey;
  void Function(ProgressHookType)? progressHook;

  Chat({
    Signer? signer,
    required String account,
    String? decryptedPgpPvtKey,
    String? pgpPublicKey,
    required this.progressHook,
  }) {
    _signer = signer;
    _account = account;
    _decryptedPgpPvtKey = decryptedPgpPvtKey;

    _userAPI = UserAPI(account: account);
  }

  late final UserAPI _userAPI;
  bool get _hasSigner => _signer != null;

  Future<List<Feeds>?> list({
    required ChatListType type,
    int page = 1,
    int limit = 10,
    String? overrideAccount,
  }) async {
    switch (type) {
      case ChatListType.CHATS:
        return PUSH_CHAT.chats(
          accountAddress: overrideAccount ?? _account,
          limit: limit,
          page: page,
          pgpPrivateKey: _decryptedPgpPvtKey,
          toDecrypt: _hasSigner,
        );
      case ChatListType.REQUESTS:
        return PUSH_CHAT.requests(
          accountAddress: overrideAccount ?? _account,
          limit: limit,
          page: page,
          pgpPrivateKey: _decryptedPgpPvtKey,
          toDecrypt: _hasSigner,
        );
    }
  }

  Future<Message?> latest({required String target}) async {
    final threadHash = await PUSH_CHAT.conversationHash(
      conversationId: target,
      accountAddress: _account,
    );
    if (threadHash == null) {
      return null;
    }

    return PUSH_CHAT.latest(
      threadhash: threadHash,
      accountAddress: _account,
      pgpPrivateKey: _decryptedPgpPvtKey,
      toDecrypt: _hasSigner,
    );
  }

  Future<List<Message>?> history({
    required String target,
    String? reference,
    int limit = FetchLimit.DEFAULT,
  }) async {
    if (reference == null) {
      final threadHash = await PUSH_CHAT.conversationHash(
        conversationId: target,
        accountAddress: _account,
      );
      reference = threadHash;
    }

    if (reference == null) {
      return [];
    }

    return PUSH_CHAT.history(
      threadhash: reference,
      limit: limit,
      accountAddress: _account,
      pgpPrivateKey: _decryptedPgpPvtKey,
      toDecrypt: _hasSigner,
    );
  }

  Future<MessageWithCID?> send(
      {required String recipient, required SendMessage options}) async {
    if (!_hasSigner) {
      throw Exception(PushAPI.ensureSignerMessage());
    }

    final chatOptions = ChatSendOptions(
      to: recipient,
      message: options,
      account: _account,
      pgpPrivateKey: _decryptedPgpPvtKey,
    );

    return PUSH_CHAT.send(chatOptions);
  }

  Future<List<Message>> decrypt(
      {required List<Message> messagePayloads}) async {
    if (!_hasSigner) {
      throw Exception(PushAPI.ensureSignerMessage());
    }
    return PUSH_CHAT.decryptConversation(
      messages: messagePayloads,
      connectedUser: await _userAPI.info(),
      pgpPrivateKey: _decryptedPgpPvtKey!,
    );
  }

  Future<String?> accept({required String target}) async {
    if (!_hasSigner) {
      throw Exception(PushAPI.ensureSignerMessage());
    }
    return PUSH_CHAT.approve(
      senderAddress: target,
      account: _account,
      pgpPrivateKey: _decryptedPgpPvtKey,
      signer: _signer,
    );
  }

  Future<String?> reject({required String target}) async {
    if (!_hasSigner) {
      throw Exception(PushAPI.ensureSignerMessage());
    }
    return PUSH_CHAT.reject(
      senderAddress: target,
      account: _account,
      pgpPrivateKey: _decryptedPgpPvtKey,
      signer: _signer,
    );
  }

  Future<User?> block({required List<String> users}) async {
    if (!_hasSigner || _decryptedPgpPvtKey == null) {
      throw Exception(PushAPI.ensureSignerMessage());
    }

    final user = await PUSH_USER.getUser(address: _account);

    for (var element in users) {
      if (!isValidETHAddress(element)) {
        throw Exception('Invalid address in the users: $element');
      }
    }

    if (user!.profile!.blockedUsersList == null) {
      user.profile?.blockedUsersList = [];
    }

    user.profile?.blockedUsersList =
        <String>{...user.profile!.blockedUsersList!, ...users}.toList();

    if (_decryptedPgpPvtKey == null) {
      throw Exception(PushAPI.ensureSignerMessage());
    }

    return PUSH_USER.profileUpdate(
      pgpPrivateKey: _decryptedPgpPvtKey!,
      account: _account,
      profile: Profile(
          name: user.profile!.name,
          desc: user.profile!.desc,
          picture: user.profile!.picture,
          blockedUsersList: user.profile?.blockedUsersList),
    );
  }

  Future<User?> unblock({required List<String> users}) async {
    if (!_hasSigner || _decryptedPgpPvtKey == null) {
      throw Exception(PushAPI.ensureSignerMessage());
    }

    final user = await PUSH_USER.getUser(address: _account);

    for (var element in users) {
      if (!isValidETHAddress(element)) {
        throw Exception('Invalid address in the users: $element');
      }
    }

    if (user!.profile!.blockedUsersList == null) {
      return user;
    }

    final userDIDs =
        await Future.wait(users.map((e) async => await getUserDID(address: e)));

    user.profile!.blockedUsersList = user.profile!.blockedUsersList!
        .where((element) => !userDIDs.contains(element))
        .toList();

    return PUSH_USER.profileUpdate(
      pgpPrivateKey: _decryptedPgpPvtKey!,
      account: _account,
      profile: Profile(
          name: user.profile!.name,
          desc: user.profile!.desc,
          picture: user.profile!.picture,
          blockedUsersList: user.profile?.blockedUsersList),
    );
  }
}
