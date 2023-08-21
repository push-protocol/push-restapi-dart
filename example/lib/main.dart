import 'package:example/functions/video/__video.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';
import 'package:riverpod/riverpod.dart';

import '__lib.dart';
import 'package:ethers/signers/wallet.dart' as ether;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  //testSendVideoCallNotification();

  // testFetchRequests();
  // testVideoInitialise();

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
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
