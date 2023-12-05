import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<String?> approve({
  required String senderAddress,
  String? account,
  Signer? signer,
  String? pgpPrivateKey,
  String status = 'Approved',
}) async {
  try {
    account ??= getCachedWallet()?.address;
    signer ??= getCachedWallet()?.signer;
    if (account == null && signer == null) {
      throw Exception('At least one from account or signer is necessary!');
    }

    final wallet = getWallet(address: account, signer: signer);
    final address = getAccountAddress(wallet);

    pgpPrivateKey ??= getCachedWallet()?.pgpPrivateKey;
    if (pgpPrivateKey == null) {
      throw Exception('Private Key is required.');
    }

    final isGroup = !isValidETHAddress(senderAddress);

    late String fromDID, toDID;

    if (isGroup) {
      fromDID = await getUserDID(address: address);
      toDID = await getUserDID(address: senderAddress);
    } else {
      fromDID = await getUserDID(address: senderAddress);
      toDID = await getUserDID(address: address);
    }

    final bodyToBeHashed = {
      "fromDID": fromDID,
      "toDID": toDID,
      "status": status,
    };
    final hash = generateHash(bodyToBeHashed);

    final signature = await sign(
      message: hash,
      privateKey: pgpPrivateKey,
    );

    final sigType = "pgp";
    final body = {
      "fromDID": fromDID,
      "toDID": toDID,
      "signature": signature,
      "status": status,
      "sigType": sigType,
      "verificationProof": '$sigType:$signature',
    };

    final result = await http.put(
      path: '/v1/chat/request/accept',
      data: body,
      skipJsonDecode: true,
    );

    log('accept result: $result');

    if (result == null) {
      return null;
    }

    if (result is String) {
      return result;
    }

    return result['data'];
  } catch (e) {
    log(e);
    throw Exception('[Push SDK] - API chats: $e');
  }
}
