import '../../../push_restapi_dart.dart';

class PushAPI {
  late final Signer? _signer;
  late final String _account;
  late final String? _decryptedPgpPvtKey;
  final String? pgpPublicKey;
  final bool readMode;

  void Function(ProgressHookType)? progressHook;

  String get account => _account;
  String? get decryptedPgpPvtKey => _decryptedPgpPvtKey;

  late Chat chat;
  late PushStream stream;
  late Space space;
  PushAPI({
    Signer? signer,
    required String account,
    String? decryptedPgpPvtKey,
    this.pgpPublicKey,
    this.progressHook,
    this.readMode = false,
    ENV env = ENV.prod,
    bool showHttpLog = false,
  }) {
    _signer = signer;
    _account = account;
    _decryptedPgpPvtKey = decryptedPgpPvtKey;

    initPush(
      env: env,
      showHttpLog: showHttpLog,
    );

    chat = Chat(
      signer: _signer,
      account: _account,
      decryptedPgpPvtKey: _decryptedPgpPvtKey,
      pgpPublicKey: pgpPublicKey,
      progressHook: progressHook,
    );
    space = Space(
      signer: _signer,
      account: _account,
      decryptedPgpPvtKey: _decryptedPgpPvtKey,
      pgpPublicKey: pgpPublicKey,
      progressHook: progressHook,
    );
  }

  static Future<PushAPI> initialize({
    Signer? signer,
    PushAPIInitializeOptions? options,
  }) async {
    options ??= PushAPIInitializeOptions();
    if (signer == null && options.account == null) {
      throw Exception("Either 'signer' or 'account' must be provided.");
    }

    final readMode = signer != null;

    // Get account
    // Derives account from signer if not provided
    String? derivedAccount;

    if (signer != null) {
      derivedAccount = getAccountAddress(
          getWallet(address: options.account, signer: signer));
    } else {
      derivedAccount = options.account;
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
          toUpgrade: options.autoUpgrade,
          progressHook: options.progressHook,
          additionalMeta: options.versionMeta,
          encryptedPGPPrivateKey: user.encryptedPrivateKey!,
          wallet: getWallet(address: options.account, signer: signer),
        );
        pgpPublicKey = user.publicKey;
      } else {
        final newUser = await createUser(
          signer: signer,
          progressHook: options.progressHook ?? (_) {},
          version: options.version ?? ENCRYPTION_TYPE.PGP_V3,
        );
        decryptedPGPPrivateKey = newUser.decryptedPrivateKey;
        pgpPublicKey = newUser.publicKey;
      }
    }

    final api = PushAPI(
      account: derivedAccount.toLowerCase(),
      env: options.env,
      signer: signer,
      decryptedPgpPvtKey: decryptedPGPPrivateKey,
      pgpPublicKey: pgpPublicKey,
      readMode: readMode,
      showHttpLog: options.showHttpLog,
    );

    return api;
  }

  Future<PushStream> initStream(
      {required List<STREAM> listen,
      PushStreamInitializeOptions? options}) async {
    stream = await PushStream.initialize(
      account: _account,
      listen: listen,
      decryptedPgpPvtKey: _decryptedPgpPvtKey,
      options: options,
      progressHook: progressHook,
      signer: _signer,
    );

    return stream;
  }

  Future<User?> info({String? overrideAccount}) async {
    return getUser(address: overrideAccount ?? _account);
  }

  static String ensureSignerMessage() {
    return 'Operation not allowed in read-only mode. Signer is required.';
  }
}
