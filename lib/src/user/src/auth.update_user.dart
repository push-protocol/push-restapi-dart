import 'dart:convert';

import '../../../push_restapi_dart.dart';

Future<User?> authUpdate({
  required String pgpPrivateKey,
  required String pgpEncryptionVersion,
  Wallet? wallet,
  required String pgpPublicKey,
  required String account,
  Map<String, dynamic>? additionalMeta,
}) async {
  try {
    final address = wallet?.address ?? account;
    wallet ??= getWallet(address: address);

    if (!isValidETHAddress(address)) {
      throw Exception('Invalid address!');
    }

    final caip10 = walletToPCAIP10(address);
    final user = await getUser(address: caip10);

    if (user == null) {
      throw Exception('User not Found!');
    }

    final signedPublicKey = await preparePGPPublicKey(
        encryptionType: pgpEncryptionVersion,
        generatedPublicKey: pgpPublicKey,
        wallet: wallet);

    final EncryptedPrivateKeyModel encryptedPgpPrivateKey = await encryptPGPKey(
        encryptionType: pgpEncryptionVersion,
        generatedPrivateKey: pgpPrivateKey,
        wallet: wallet,
        additionalMeta: additionalMeta);

    if (pgpEncryptionVersion == ENCRYPTION_TYPE.NFTPGP_V1) {
      print("authUpdate...ENCRYPTION_TYPE.NFTPGP_V1...s");
      final encryptedPassword = await encryptPGPKey(
        encryptionType: ENCRYPTION_TYPE.PGP_V3,
        additionalMeta: additionalMeta,
        wallet: wallet,
        generatedPrivateKey: jsonEncode(additionalMeta),
      );

      encryptedPgpPrivateKey.encryptedPassword = encryptedPassword;
    }

    final updatedUser = await authUpdateUserService(
      address: user.did!,
      wallet: wallet,
      publicKey: signedPublicKey,
      encryptedPrivateKey: jsonEncode(encryptedPgpPrivateKey),
    );

    return updatedUser;
  } catch (err) {
    log('[Push SDK] - API - Error - API upgrade -: $err');
    rethrow;
  }
}
