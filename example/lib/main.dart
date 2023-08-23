import 'package:push_restapi_dart/push_restapi_dart.dart';

import '__lib.dart';
import 'package:ethers/signers/wallet.dart' as ether;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'functions/space/trending_spaces.dart';

void main() async {
  //testSendVideoCallNotification();

  // testFetchRequests();
  // testVideoInitialise();

  await exampleInit();
  testTrendingSpace();

  // runApp(
  //   ProviderScope(
  //     child: const MyApp(),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
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
