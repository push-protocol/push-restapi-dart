import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<MessageWithCID?> send({
  required String messageContent,
  required String receiverAddress,
  String messageType = 'Text',
  String? accountAddress,
  Signer? signer,
  String? pgpPrivateKey,
  required String apiKey,
}) async {
  accountAddress ??= getCachedWallet()?.address;
  signer ??= getCachedWallet()?.signer;
  if (accountAddress == null) {
    throw Exception('Account address is required.');
  }
  if (signer == null) {
    throw Exception('Signer is necessary!');
  }

  if (!isValidETHAddress(accountAddress)) {
    throw Exception('Invalid address $accountAddress');
  }

  pgpPrivateKey ??= getCachedWallet()?.pgpPrivateKey;
  if (pgpPrivateKey == null) {
    throw Exception('Private Key is required.');
  }

  try {
    final wallet = getWallet(address: accountAddress, signer: signer);
    String address = getAccountAddress(wallet);

    bool isGroup = !isValidETHAddress(receiverAddress);

    final connectedUser = await getConnectedUserV2(wallet: wallet);
    final receiver = await getUserDID(address: receiverAddress);

    String? conversationResponse;

    if (isGroup) {
      conversationResponse = await conversationHash(
        conversationId: receiver,
        account: address,
      );
    }

    log('conversationResponse: $conversationResponse');

    if (conversationResponse != null) {
      log('conversationResponse 1: $conversationResponse');
      return start(
        receiverAddress: receiverAddress,
        apiKey: apiKey,
        connectedUser: connectedUser,
        messageContent: messageContent,
        messageType: messageType,
      );
    } else {
      log('conversationResponse 2: $conversationResponse');
      final body = await sendMessagePayload(
          receiverAddress: receiverAddress,
          senderCreatedUser: connectedUser!,
          messageContent: messageContent,
          messageType: messageType);
      final result =
          await http.post(path: '/v1/chat/message', data: body.toJson());

      if (result == null) {
        return null;
      }
      return MessageWithCID.fromJson(result);
    }
  } catch (err) {
    log('[Push SDK] - API history - : $err');
    throw Exception('[Push SDK] - API history - : $err');
  }
}
