// ignore_for_file: slash_for_doc_comments

import 'dart:convert';

import '../../../push_restapi_dart.dart';

class Encryption {
  late final Signer? _signer;
  late final ENV env;
  late final String _account;
  late final String? _decryptedPgpPvtKey;
  late final String? _pgpPublicKey;
  void Function(ProgressHookType)? progressHook;

  late final UserAPI userInstance;

  Encryption({
    Signer? signer,
    required String account,
    String? decryptedPgpPvtKey,
    String? pgpPublicKey,
    required this.env,
    required this.progressHook,
  }) {
    _pgpPublicKey = pgpPublicKey;
    _signer = signer;
    _account = account;
    _decryptedPgpPvtKey = decryptedPgpPvtKey;

    userInstance = UserAPI(account: account);
  }

  Future<dynamic> info() async {
    final userInfo = await userInstance.info();
    String? decryptedPassword;
    if (_signer == null) {
      final meta = {};
      meta['NFTPGP_V1']['encryptedPassword'] =
          (jsonDecode(userInfo!.encryptedPrivateKey!)
              as Map<String, dynamic>)['encryptedPassword'];
      decryptedPassword = await decryptAuth(
        account: _account,
        signer: _signer,
        additionalMeta: meta,
      );
    }

    return {
      'decryptedPgpPrivateKey': _decryptedPgpPvtKey,
      'pgpPublicKey': _pgpPublicKey,
      if (decryptedPassword != null) 'decryptedPassword': decryptedPassword,
    };
  }

/**
     options?: {
      versionMeta?: {
        NFTPGP_V1?: { password: string };
      };
    }
 */
  Future<dynamic> update(
      {required EncryptionType updatedEncryptionType,
      Map<String, dynamic>? options}) async {
    if (options != null) {
      assert(options.keys.contains("versionMeta"));
      assert(options["versionMeta"].keys.contains("NFTPGP_V1"));
    }

    if (_signer == null) {
      throw Exception(PushAPI.ensureSignerMessage());
    }

    if (_decryptedPgpPvtKey == null || _pgpPublicKey == null) {
      throw Exception(PushAPI.ensureSignerMessage());
    }

    return authUpdate(
        pgpEncryptionVersion: updatedEncryptionType.value,
        additionalMeta: options?["versionMeta"],
        pgpPrivateKey: _decryptedPgpPvtKey!,
        pgpPublicKey: _pgpPublicKey!,
        account: _account,
        wallet: getWallet(address: _account, signer: _signer));
  }
}
