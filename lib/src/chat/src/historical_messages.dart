// ignore_for_file: constant_identifier_names

import '../../../push_restapi_dart.dart';

class FetchLimit {
  static const MIN = 1;
  static const DEFAULT = 10;
  static const MAX = 30;
}

Future<List<Message>?> history({
  required String threadhash,
  String? accountAddress,
  int limit = FetchLimit.DEFAULT,
  String? pgpPrivateKey,
  bool toDecrypt = false,
}) async {
  accountAddress ??= getCachedWallet()?.address;
  if (accountAddress == null) {
    throw Exception('Account address is required.');
  }

  if (!isValidETHAddress(accountAddress)) {
    throw Exception('Invalid address $accountAddress');
  }

  pgpPrivateKey ??= getCachedWallet()?.pgpPrivateKey;
  if (pgpPrivateKey == null) {
    throw Exception('Private Key is required.');
  }

  try {
    if (limit < FetchLimit.MIN || limit > FetchLimit.MAX) {
      if (limit < FetchLimit.MIN) {
        throw Exception('Limit must be more than equal to ${FetchLimit.MIN}');
      } else {
        throw Exception('Limit must be less than equal to ${FetchLimit.MAX}');
      }
    }

    final List<Message>? messages =
        await getMessagesService(threadhash: threadhash, limit: limit);

    if (messages == null) {
      return null;
    }

    final updatedMessages = addDeprecatedInfoToMessages(messages);
    final connectedUser =
        await getUser(address: pCAIP10ToWallet(accountAddress));

    if (toDecrypt) {
      return await decryptConversation(
        messages: updatedMessages,
        connectedUser: connectedUser,
        pgpPrivateKey: pgpPrivateKey,
      );
    }
    return messages;
  } catch (err) {
    log('[Push SDK] - API history - : $err');
    throw Exception('[Push SDK] - API history - : $err');
  }
}
