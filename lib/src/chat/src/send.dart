import 'dart:convert';

import '../../../push_restapi_dart.dart';

class ChatSendOptions {
  SendMessage? message;
  String? messageContent;
  String? messageType;
  String receiverAddress;
  String? accountAddress;
  String? pgpPrivateKey;

  ChatSendOptions(
      {this.message,
      this.messageContent,
      this.messageType,
      required this.receiverAddress,
      this.accountAddress,
      this.pgpPrivateKey}) {
    assert(MessageType.isValidMessageType(
        message?.type ?? messageType ?? MessageType.TEXT));
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message?.toJson(),
      'messageContent': messageContent,
      'messageType': messageType,
      'receiverAddress': receiverAddress,
      'accountAddress': accountAddress,
      'pgpPrivateKey': pgpPrivateKey
    };
  }
}

Future<MessageWithCID?> send(ChatSendOptions options) async {
  log('SEND - OPTIONS ${options.toJson()}');

  ComputedOptions computedOptions = computeOptions(options);

  log('SEND - COMPUTED OPTIONS ${computedOptions.toJson()}');

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
      throw Exception('Cannot get sender account.');
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
        receiverAddress: computedOptions.to,
        senderPublicKey: getPublicKeyFromString(senderAcount.publicKey!),
        senderPgpPrivateKey: computedOptions.pgpPrivateKey,
        senderAddress: computedOptions.accountAddress,
        publicKeys: isValidGroup
            ? groupReciverAccounts
            : [
                getPublicKeyFromString(senderAcount.publicKey!),
                getPublicKeyFromString(receiverAccount!.publicKey!)
              ],
        messageType: computedOptions.messageType,
        messageContent: messageContent,
        messageObj: computedOptions.messageObj,
        group: group,
        isValidGroup: isValidGroup);

    log('sendMessagePayload $sendMessagePayload');

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

Future<SendMessagePayload> getSendMessagePayload({
  required String receiverAddress,
  String? senderAddress,
  String? senderPgpPrivateKey,
  required String senderPublicKey,
  required String messageType,
  required String messageContent,
  dynamic messageObj,
  List<String> publicKeys = const [],
  GroupDTO? group,
  required bool isValidGroup,
}) async {
  log('encryptedMessageContentData --> getSendMessagePayload - receiverAddress: $receiverAddress, message: $messageContent, isGroup: $isValidGroup');

  final secretKey = generateRandomSecret(15);

  final encryptedMessageContentData = await getEncryptedRequest(
      receiverAddress: receiverAddress,
      senderPublicKey: senderPublicKey,
      senderPgpPrivateKey: senderPgpPrivateKey!,
      message: messageContent,
      isGroup: isValidGroup,
      group: group,
      secretKey: secretKey);
  final encryptedMessageContent = encryptedMessageContentData.message;
  final deprecatedSignature =
      removeVersionFromPublicKey(encryptedMessageContentData.signature);

  final encryptedMessageObjData = await getEncryptedRequest(
      receiverAddress: receiverAddress,
      senderPublicKey: senderPublicKey,
      senderPgpPrivateKey: senderPgpPrivateKey,
      message: jsonEncode(messageObj?.toJson()),
      isGroup: isValidGroup,
      group: group,
      secretKey: secretKey);
  final encryptedMessageObj = encryptedMessageObjData.message;
  final encryptionType = encryptedMessageObjData.encryptionType;
  final encryptedMessageObjSecret =
      removeVersionFromPublicKey(encryptedMessageObjData.aesEncryptedSecret);

  return SendMessagePayload(
      fromDID: validateCAIP(senderAddress!)
          ? senderAddress
          : walletToPCAIP10(senderAddress),
      toDID: !isValidGroup
          ? validateCAIP(receiverAddress)
              ? receiverAddress
              : walletToPCAIP10(receiverAddress)
          : group?.chatId ?? '',
      fromCAIP10: validateCAIP(senderAddress)
          ? senderAddress
          : walletToPCAIP10(senderAddress),
      toCAIP10: !isValidGroup
          ? validateCAIP(receiverAddress)
              ? receiverAddress
              : walletToPCAIP10(receiverAddress)
          : group?.chatId ?? '',
      messageContent: encryptedMessageContent,
      messageObj: encryptionType == 'PlainText'
          ? messageObj?.toJson()
          : encryptedMessageObj,
      messageType: messageType,
      signature: deprecatedSignature,
      verificationProof: "pgp:$deprecatedSignature",
      encType: encryptionType,
      encryptedSecret: encryptedMessageObjSecret,
      sigType: "pgp");
}

class ComputedOptions {
  String messageType;
  dynamic messageObj;
  String to;
  String? accountAddress;
  String? pgpPrivateKey;

  ComputedOptions(
      {required this.messageType,
      required this.to,
      this.messageObj,
      this.accountAddress,
      this.pgpPrivateKey});

  Map<String, dynamic> toJson() {
    return {
      'messageType': messageType,
      'messageObj': messageObj,
      'to': to,
      'accountAddress': accountAddress,
      'pgpPrivateKey': pgpPrivateKey
    };
  }
}

ComputedOptions computeOptions(ChatSendOptions options) {
  log('computeOptions method - options $options');
  String messageType =
      options.message?.type ?? options.messageType ?? MessageType.TEXT;
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
      pgpPrivateKey: options.pgpPrivateKey);
}
