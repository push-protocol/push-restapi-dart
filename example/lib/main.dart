import 'package:push_restapi_dart/push_restapi_dart.dart';

import '__lib.dart';
import 'package:ethers/signers/wallet.dart' as ether;

void main() async {
  // testSendVideoCallNotification();
  await exampleInit();
  testFetchLatestChat();
}

exampleInit() async {
  WidgetsFlutterBinding.ensureInitialized();

  const mnemonic =
      'coconut slight random umbrella print verify agent disagree endorse october beyond bracket';
  final ethersWallet = ether.Wallet.fromMnemonic(mnemonic);
  final signer = EthersSigner(
    ethersWallet: ethersWallet,
    address: ethersWallet.address!,
  );

  print('walletMnemonic.address: ${ethersWallet.address}');
  final user = await getUser(address: ethersWallet.address!);

  if (user == null) {
    print('Cannot get user');
    return;
  }

  String? pgpPrivateKey = null;
  if (user.encryptedPrivateKey != null) {
    pgpPrivateKey = await decryptPGPKey(
      encryptedPGPPrivateKey: user.encryptedPrivateKey!,
      wallet: getWallet(signer: signer),
    );
  }

  print('pgpPrivateKey: $pgpPrivateKey');

  final pushWallet = Wallet(
    address: ethersWallet.address,
    signer: signer,
    pgpPrivateKey: pgpPrivateKey,
  );

  await initPush(
    wallet: pushWallet,
    env: ENV.staging,
  );
}
