import 'package:push_restapi_dart/push_restapi_dart.dart';
import 'package:example/user/create_user.dart';
import 'package:ethers/signers/wallet.dart' as ether;

void handleProgress(progressType) {
  print(progressType);
}

testCreatPushProfile() async {
  const mnemonic =
      'indoor observe crack rocket sea abstract mixed novel angry alone away pass';
  final walletMnemonic = ether.Wallet.fromMnemonic(mnemonic);
  final signer = SignerPrivateKey(
      wallet: walletMnemonic, address: walletMnemonic.address!);
  // final result = createUser(signer: signer, progressHook: handleProgress);
  // print(result);
  print('walletMnemonic.address: ${walletMnemonic.address}');
  final user = await getUser(address: walletMnemonic.address!);

  String? pvtkey = null;
  // if (user?.encryptedPrivateKey != null) {
  //   pvtkey = await decryptPGPKey(
  //     encryptedPGPPrivateKey: user!.encryptedPrivateKey!,
  //     wallet: getWallet(signer: signer),
  //   );
  // }
      pvtkey = await decryptPGPKey(
      encryptedPGPPrivateKey: user!.encryptedPrivateKey!,
      wallet: getWallet(signer: signer),
    );
  print("pgp-pvt-key");
  print(pvtkey);
}
