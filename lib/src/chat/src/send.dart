import 'dart:convert';

import '../../../push_restapi_dart.dart';

class ChatSendOptions {
  SendMessage? message;
  String? messageContent;
  String messageType;
  String receiverAddress;
  String? accountAddress;
  String? pgpPrivateKey;
  String? senderPgpPubicKey;

  ChatSendOptions({
    this.message,
    this.messageContent,
    this.messageType = MessageType.TEXT,
    required this.receiverAddress,
    this.accountAddress,
    this.pgpPrivateKey,
    this.senderPgpPubicKey,
  }) {
    assert(MessageType.isValidMessageType(messageType));
  }
}

Future<MessageWithCID?> send(ChatSendOptions options) async {
  ComputedOptions computedOptions = computeOptions(options);

  computedOptions.accountAddress ??= getCachedWallet()?.address;
  if (computedOptions.accountAddress == null) {
    throw Exception('Account address is required.');
  }

  final isValidGroup = isGroup(computedOptions.to);
  final group =
      isValidGroup ? await getGroup(chatId: computedOptions.to) : null;

  if (computedOptions.messageType == MessageType.REACTION) {
    computedOptions.messageObj?.content =
        REACTION_SYMBOL[computedOptions.messageObj?.action];
  }

  final conversationHashResponse = await conversationHash(
    conversationId: computedOptions.to,
    accountAddress: computedOptions.accountAddress!,
  );

  if (!isValidETHAddress(computedOptions.accountAddress!)) {
    throw Exception('Invalid address ${computedOptions.accountAddress}');
  }

  computedOptions.pgpPrivateKey ??= getCachedWallet()?.pgpPrivateKey;
  if (computedOptions.pgpPrivateKey == null) {
    throw Exception('Private Key is required.');
  }

  bool isIntent = !isValidGroup && conversationHashResponse == null;
  await validateSendOptions(computedOptions);

  try {
    final senderAcount =
        await getUser(address: computedOptions.accountAddress!);

    if (senderAcount == null) {
      throw Exception('Cannot get sender account address .');
    }
    // check if user exists
    User? receiverAccount;
    List<String> groupReciverAccounts = [];
    if (!isValidGroup) {
      receiverAccount = await getUser(address: computedOptions.to);
      // else create the user frist and send unencrypted intent message
      receiverAccount ??=
          await createUserEmpty(accountAddress: computedOptions.to);
    } else {
      for (int i = 0; i < (group?.members.length ?? 0); i++) {
        groupReciverAccounts.add(group!.members[i].publicKey!);
      }
      groupReciverAccounts.add(getPublicKeyFromString(senderAcount.publicKey!));
    }

    final messageContent = computedOptions.messageObj?.content;

    final sendMessagePayload = await getSendMessagePayload(
        senderPublicKey: getPublicKeyFromString(senderAcount.publicKey!),
        options: CustomComputedOptions(
          messageContent: messageContent,
          messageType: computedOptions.messageType,
          to: computedOptions.to,
          messageObj: computedOptions.messageObj,
          accountAddress: computedOptions.accountAddress,
          pgpPrivateKey: computedOptions.pgpPrivateKey,
          senderPgpPubicKey: computedOptions.senderPgpPubicKey,
        ),
        publicKeys: isValidGroup
            ? groupReciverAccounts
            : [
                getPublicKeyFromString(senderAcount.publicKey!),
                getPublicKeyFromString(receiverAccount!.publicKey!)
              ],
        group: group,
        isValidGroup: isValidGroup,
        shouldEncrypt: false);
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
    print(result);
    if (result == null || result is String) {
      return null;
    }
    return MessageWithCID.fromJson(result);
  } catch (e) {
    log("[Push SDK] - API $e");
    rethrow;
  }
}

validateSendOptions(ComputedOptions options) async {
  if (options.accountAddress == null) {
    throw Exception('Account address is required.');
  }

  if (!isValidETHAddress(options.accountAddress!)) {
    throw Exception('Invalid address ${options.accountAddress}');
  }

  if (options.pgpPrivateKey == null) {
    throw Exception('Private Key is required.');
  }

  final isGroup = isValidETHAddress(options.to) ? false : true;

  if (isGroup) {
    final group = await getGroup(chatId: options.to);
    if (group == null) {
      throw Exception(
          'Invalid receiver. Please ensure \'receiver\' is a valid DID or ChatId in case of Group.');
    }
  }

  if (options.messageObj?.content.isEmpty) {
    throw Exception('Cannot send empty message');
  }
}

class CustomComputedOptions extends ComputedOptions {
  String messageContent;

  CustomComputedOptions({
    required String messageType,
    required String to,
    dynamic messageObj,
    String? accountAddress,
    String? pgpPrivateKey,
    String? senderPgpPubicKey,
    required this.messageContent,
  }) : super(
          messageType: messageType,
          to: to,
          messageObj: messageObj,
          accountAddress: accountAddress,
          pgpPrivateKey: pgpPrivateKey,
          senderPgpPubicKey: senderPgpPubicKey,
        );
}

Future<SendMessagePayload> getSendMessagePayload(
    {required CustomComputedOptions options,
    required String senderPublicKey,
    List<String> publicKeys = const [],
    bool shouldEncrypt = true,
    GroupDTO? group,
    bool isValidGroup = false}) async {
  String encType = shouldEncrypt ? 'pgp' : 'PlainText';
  String messageContent = options.messageContent;

  final encryptedMessageContentData = await encryptAndSign(
    plainText: messageContent,
    keys: publicKeys,
    senderPgpPrivateKey: options.pgpPrivateKey!,
    publicKey: senderPublicKey,
  );
  final encryptedMessageContent =
      encryptedMessageContentData['cipherText'] as String;
  final deprecatedSignature =
      removeVersionFromPublicKey(encryptedMessageContentData['signature']!);

  final encryptedMessageObjData = await encryptAndSign(
      plainText: jsonEncode(options.messageObj?.toJson()),
      keys: publicKeys,
      senderPgpPrivateKey: options.pgpPrivateKey!,
      publicKey: senderPublicKey);
  final encryptedMessageObj = encryptedMessageObjData['cipherText'] as String;
  final encryptedMessageObjSecret =
      encryptedMessageObjData['encryptedSecret'] as String;

  return SendMessagePayload(
      fromDID: validateCAIP(options.accountAddress!)
          ? options.accountAddress!
          : walletToPCAIP10(options.accountAddress!),
      toDID: !isValidGroup
          ? validateCAIP(options.to)
              ? options.to
              : walletToPCAIP10(options.to)
          : group?.chatId ?? '',
      fromCAIP10: validateCAIP(options.accountAddress!)
          ? options.accountAddress!
          : walletToPCAIP10(options.accountAddress!),
      toCAIP10: !isValidGroup
          ? validateCAIP(options.to)
              ? options.to
              : walletToPCAIP10(options.to)
          : group?.chatId ?? '',
      messageContent: encryptedMessageContent,
      messageObj: encType == 'PlainText'
          ? options.messageObj?.toJson()
          : encryptedMessageObj,
      messageType: options.messageType,
      signature: deprecatedSignature,
      verificationProof: "pgp:$deprecatedSignature",
      encType: encType,
      encryptedSecret: removeVersionFromPublicKey(encryptedMessageObjSecret),
      sigType: "pgp");
}

class ComputedOptions {
  String messageType;
  dynamic messageObj;
  String to;
  String? accountAddress;
  String? pgpPrivateKey;
  String? senderPgpPubicKey;

  ComputedOptions({
    required this.messageType,
    required this.to,
    this.messageObj,
    this.accountAddress,
    this.pgpPrivateKey,
    this.senderPgpPubicKey,
  });
}

ComputedOptions computeOptions(ChatSendOptions options) {
  log('computeOptions method - options $options');
  String messageType = options.messageType;
  var messageObj = options.message;
  if (messageObj == null) {
    if (![
      MessageType.TEXT,
      MessageType.IMAGE,
      MessageType.FILE,
      MessageType.MEDIA_EMBED,
      MessageType.GIF
    ].contains(messageType)) {
      throw Exception('Options.message is required');
    } else if (options.messageContent != null) {
      // use messageContent for backwards compatibility
      messageObj = SendMessage(
        content: options.messageContent!,
        type: messageType,
      );
    }
  }

  String to = options.receiverAddress;
  if (to.isEmpty) {
    throw Exception('Options.to is required');
  }

  return ComputedOptions(
    messageType: messageType,
    messageObj: messageObj,
    to: to,
    accountAddress: options.accountAddress,
    pgpPrivateKey: options.pgpPrivateKey,
    senderPgpPubicKey: options.senderPgpPubicKey,
  );
}
