import '../../push_restapi_dart.dart';

class PushApi {
  final Signer? signer;
  final String account;
  final String? decryptedPgpPvtKey;
  final String? pgpPublicKey;
  final bool readMode;

  void Function(ProgressHookType)? progressHook;

  PushApi({
    this.signer,
    required this.account,
    this.decryptedPgpPvtKey,
    this.pgpPublicKey,
    this.progressHook,
    this.readMode = false,
  });

  static Future<PushApi> initialize(
      {Signer? signer, PushAPIInitializeProps? options}) async {
    if (signer == null && options?.account == null) {
      throw Exception("Either 'signer' or 'account' must be provided.");
    }

    final readMode = signer != null;

    // Get account
    // Derives account from signer if not provided
    String? derivedAccount;

    if (signer != null) {
      derivedAccount = getAccountAddress(
          getWallet(address: options?.account, signer: signer));
    } else {
      derivedAccount = options?.account;
    }

    if (derivedAccount == null) {
      throw Exception('Account could not be derived.');
    }

    String? decryptedPGPPrivateKey;
    String? pgpPublicKey;

    /**
       * Decrypt PGP private key
       * If user exists, decrypts the PGP private key
       * If user does not exist, creates a new user and returns the decrypted PGP private key
       */
    final user = await getUser(address: derivedAccount);

    if (readMode) {
      if (user != null && user.encryptedPrivateKey != null) {
        decryptedPGPPrivateKey = await decryptPGPKey(
          toUpgrade: options?.autoUpgrade,
          progressHook: options?.progressHook,
          additionalMeta: options?.versionMeta,
          encryptedPGPPrivateKey: user.encryptedPrivateKey!,
          wallet: getWallet(address: options?.account, signer: signer),
        );
        pgpPublicKey = user.publicKey;
      } else {
        final newUser = await createUser(
          signer: signer,
          progressHook: options?.progressHook ?? (_) {},
          version: options?.version ?? ENCRYPTION_TYPE.PGP_V3,
        );
        decryptedPGPPrivateKey = newUser.decryptedPrivateKey;
        pgpPublicKey = newUser.publicKey;
      }
    }

    final api = PushApi(
      account: derivedAccount,
      signer: signer,
      decryptedPgpPvtKey: decryptedPGPPrivateKey,
      pgpPublicKey: pgpPublicKey,
      readMode: readMode,
    );

    return api;
  }
}
