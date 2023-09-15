import '../../../push_restapi_dart.dart';

/// All chat messages are stored on IPFS. This function will return the latest message's CID (Content Identifier on IPFS).
/// Whenever a new message is sent or received, this CID will change.
Future<String?> conversationHash({
  required String conversationId,
  String? accountAddress,
}) async {
  try {
    accountAddress ??= getCachedWallet()?.address;
    if (accountAddress == null) {
      throw Exception('Account address is required.');
    }

    if (!isValidETHAddress(accountAddress)) {
      throw Exception('Invalid address!');
    }

    final updatedConversationId = await getUserDID(
      address: conversationId,
    );
    final accountDID = await getUserDID(
      address: accountAddress,
    );

    final response = await getConversationHashService(
      conversationId: updatedConversationId,
      account: accountDID,
    );
    return response['threadHash'];
  } catch (e) {
    log('[Push SDK] - Error - API conversationHash: $e');
    rethrow;
  }
}
