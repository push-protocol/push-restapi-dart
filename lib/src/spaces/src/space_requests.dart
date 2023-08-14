import 'package:push_restapi_dart/push_restapi_dart.dart';

///The first time an address wants to send a message to another peer, the address sends an intent request. This first message shall not land in this peer Inbox but in its Request box.
///This function will return all the chats that landed on the address' Request box. The user can then approve the request or ignore it for now.
///
///toDecrypt: If true, the method will return decrypted message content in response
///page index - default 1
///limit: no of items per page - default 10 - max 30
Future<List<SpaceFeeds>?> spaceRequests({
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

  try {
    final String userDID = await getUserDID(address: accountAddress);
    final result = await http.get(
      path: '/v1/spaces/users/$userDID/requests?page=$page&limit=$limit',
    );

    if (result == null || result['requests'] == null) {
      return null;
    }

    final requestList = (result['requests'] as List)
        .map((e) => SpaceFeeds.fromJson(e))
        .toList();
    final updatedChats = addDeprecatedInfoSpaceFeeds(requestList);
    final feedWithInbox = await getSpaceInboxList(
      feedsList: updatedChats,
      user: userDID,
      pgpPrivateKey: pgpPrivateKey,
      toDecrypt: toDecrypt,
    );

    return feedWithInbox;
  } catch (e) {
    log(e);
    throw Exception('[Push SDK] - API requests: $e');
  }
}
