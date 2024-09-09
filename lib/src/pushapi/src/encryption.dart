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

  Future info() async {
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
}
