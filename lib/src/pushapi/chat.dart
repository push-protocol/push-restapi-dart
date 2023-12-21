// ignore_for_file: library_prefixes

import '../../push_restapi_dart.dart';
import '../chat/chat.dart' as PUSH_CHAT;

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
  }
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
      throw Exception(PushApi.ensureSignerMessage());
    }

    final chatOptions = ChatSendOptions(
      to: recipient,
      message: options,
      account: _account,
      pgpPrivateKey: _decryptedPgpPvtKey,
    );

    return PUSH_CHAT.send(chatOptions);
  }
}
