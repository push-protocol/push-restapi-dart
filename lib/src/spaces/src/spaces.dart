import '../../../push_restapi_dart.dart';

/// Return the latest message from all wallet addresses you have talked to.
/// This can be used when building the inbox page.
///
///toDecrypt: If true, the method will return decrypted message content in response
///page index - default 1
///limit: no of items per page - default 10 - max 30
Future<List<SpaceFeeds>?> spaces({
  String? accountAddress,
  String? pgpPrivateKey,
  bool toDecrypt = false,
  int page = 1,
  int limit = 10,
}) async {
  accountAddress ??= getCachedWallet()?.address;
  if (accountAddress == null) {
    throw Exception('Account address is required.');
  }

  if (!isValidETHAddress(accountAddress)) {
    throw Exception('Invalid address $accountAddress');
  }

  pgpPrivateKey ??= getCachedWallet()?.pgpPrivateKey;
  if (toDecrypt && pgpPrivateKey == null) {
    throw Exception('Private Key is required.');
  }

  if (!isValidETHAddress(accountAddress)) {
    throw Exception('Invalid address!');
  }

  try {
    final userDID = await getUserDID(address: accountAddress);
    final result = await http.get(
      path: '/v1/spaces/users/$userDID/spaces?page=$page&limit=$limit',
    );

    if (result == null || result['spaces'] == null) {
      return null;
    }

    final chatList =
        (result['spaces'] as List).map((e) => SpaceFeeds.fromJson(e)).toList();
    final updatedChats = chatList;
    addDeprecatedInfoSpaceFeeds(chatList);
    final feedWithInbox = await getSpaceInboxList(
      feedsList: updatedChats,
      user: userDID,
      pgpPrivateKey: pgpPrivateKey,
      toDecrypt: toDecrypt,
    );

    return feedWithInbox;
  } catch (e) {
    log(e);
    throw Exception('[Push SDK] - API chats: $e');
  }
}
