import 'dart:convert';

import '../../../push_restapi_dart.dart';

class ChatSendOptions {
  String messageContent;
  String messageType;
  String receiverAddress;
  String? accountAddress;
  String? pgpPrivateKey;
  String? senderPgpPubicKey;

  ChatSendOptions({
    required this.messageContent,
    this.messageType = MessageType.TEXT,
    required this.receiverAddress,
    this.accountAddress,
    this.pgpPrivateKey,
    this.senderPgpPubicKey,
  }) {
    assert(MessageType.isValidMessageType(messageType));
    receiverAddress = walletToPCAIP10(receiverAddress);
  }
}

Future<MessageWithCID?> send(ChatSendOptions options) async {
  options.accountAddress ??= getCachedWallet()?.address;
  if (options.accountAddress == null) {
    throw Exception('Account address is required.');
  }
  final isGroup =
      isValidETHAddress(options.receiverAddress.split(":")[1]) ? false : true;
  // final group =
  //     isGroup ? await getGroup(chatId: options.receiverAddress) : null;
  final conversationResponse = jsonDecode((await conversationHash(
    conversationId: options.receiverAddress,
    account: options.accountAddress!,
  ))!);
  if (!isValidETHAddress(options.accountAddress!)) {
    throw Exception('Invalid address ${options.accountAddress}');
  }

  options.pgpPrivateKey ??= getCachedWallet()?.pgpPrivateKey;
  if (options.pgpPrivateKey == null) {
    throw Exception('Private Key is required.');
  }
  bool isIntent = !isGroup && conversationResponse["threadHash"] == null;
  await validateSendOptions(options);
  try {
    final senderAcount = await getUser(address: options.accountAddress!);

    if (senderAcount == null) {
      throw Exception('Cannot get sender account address .');
    }
    // check if user exists
    User? receiverAccount = await getUser(address: options.receiverAddress);

    // else create the user frist and send unencrypted intent message
    receiverAccount ??=
        await createUserEmpty(accountAddress: options.receiverAddress);

    final sendMessagePayload = await getSendMessagePayload(
      senderPublicKey: getPublicKeyFromString(senderAcount.publicKey!),
      options: options,
      publicKeys: [
        getPublicKeyFromString(senderAcount.publicKey!),
        getPublicKeyFromString(receiverAccount!.publicKey!)
      ],
    );
    return sendMessageService(sendMessagePayload, isIntent);
  } catch (e) {
    log('[Push SDK] - API  - Error - API $e');
    rethrow;
  }
}

Future<MessageWithCID?> sendMessageService(
    SendMessagePayload payload, bool isIntent) async {
  try {
    String apiRoute;
    if (isIntent) {
      apiRoute = '/v1/chat/request';
    } else {
      apiRoute = '/v1/chat/message';
    }
    final result = await http.post(path: apiRoute, data: payload.toJson());

    if (result == null) {
      return null;
    }
    return MessageWithCID.fromJson(result);
  } catch (e) {
    log("[Push SDK] - API $e");
    rethrow;
  }
}

validateSendOptions(ChatSendOptions options) async {
  if (options.accountAddress == null) {
    throw Exception('Account address is required.');
  }

  if (!isValidETHAddress(options.accountAddress!)) {
    throw Exception('Invalid address ${options.accountAddress}');
  }

  if (options.pgpPrivateKey == null) {
    throw Exception('Private Key is required.');
  }

  final isGroup = isValidETHAddress(options.receiverAddress) ? false : true;

  if (isGroup) {
    final group = await getGroup(chatId: options.receiverAddress);
    if (group == null) {
      throw Exception(
          'Invalid receiver. Please ensure \'receiver\' is a valid DID or ChatId in case of Group.');
    }
  }
}

Future<SendMessagePayload> getSendMessagePayload({
  required ChatSendOptions options,
  required String senderPublicKey,
  List<String> publicKeys = const [],
  bool shouldEncrypt = true,
}) async {
  String encType = "PlainText";
  String signature = '';
  String encryptedSecret = '';
  String messageConent = options.messageContent;

  if (shouldEncrypt) {
    encType = "pgp";

    final encryptedData = await encryptAndSign(
      plainText: messageConent,
      keys: publicKeys,
      senderPgpPrivateKey: options.pgpPrivateKey!,
      publicKey: senderPublicKey,
    );

    messageConent = encryptedData['cipherText'] as String;
    encryptedSecret = encryptedData['encryptedSecret'] as String;
    signature = removeVersionFromPublicKey(encryptedData['signature']!);
  }

  return SendMessagePayload(
      fromDID: validateCAIP(options.accountAddress!)
          ? options.accountAddress!
          : walletToPCAIP10(options.accountAddress!),
      toDID: validateCAIP(options.receiverAddress)
          ? options.receiverAddress
          : walletToPCAIP10(options.receiverAddress),
      fromCAIP10: validateCAIP(options.accountAddress!)
          ? options.accountAddress!
          : walletToPCAIP10(options.accountAddress!),
      toCAIP10: validateCAIP(options.receiverAddress)
          ? options.receiverAddress
          : walletToPCAIP10(options.receiverAddress),
      messageContent: messageConent,
      messageType: options.messageType,
      signature: signature,
      verificationProof: "pgp:$signature",
      encType: encType,
      encryptedSecret: removeVersionFromPublicKey(encryptedSecret),
      sigType: "pgp");
}
