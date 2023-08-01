import 'package:push_restapi_dart/push_restapi_dart.dart';

/// Return the latest message from all wallet addresses you have talked to.
/// This can be used when building the inbox page.
///
///toDecrypt: If true, the method will return decrypted message content in response
///page index - default 1
///limit: no of items per page - default 10 - max 30
Future<Feeds?> chat({
  String? accountAddress,
  String? pgpPrivateKey,
  required String recipient,
  bool toDecrypt = true,
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

  final recipientWallet = await getUserDID(address: recipient);

  try {
    final String userDID = await getUserDID(address: accountAddress);
    final result = await http.get(
      path: '/v1/chat/users/$userDID/chat/$recipientWallet',
    );

    if (result == null) {
      return null;
    }

    final chatList = [Feeds.fromJson(result)];

    final updatedChats = chatList;
    // addDeprecatedInfo(chatList);
    final feedWithInbox = await getInboxList(
      feedsList: updatedChats,
      user: userDID,
      pgpPrivateKey: pgpPrivateKey,
      toDecrypt: toDecrypt,
    );

    return feedWithInbox.first;
  } catch (e) {
    log(e);
    throw Exception('[Push SDK] - API chats: $e');
  }
}
