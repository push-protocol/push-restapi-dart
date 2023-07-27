import 'package:example/models/signer.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

import 'package:ethers/signers/wallet.dart' as ethers;

void testSend() async {
  const mnemonic =
      'indoor observe crack rocket sea abstract mixed novel angry alone away pass';
  final ethersWallet = ethers.Wallet.fromMnemonic(mnemonic);
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


  final options = SendOptions(
    accountAddress: ethersWallet.address,
    pgpPrivateKey: pgpPrivateKey,
    messageContent: 'Hey again!!!!!7',
    receiverAddress: '0x69e666767Ba3a661369e1e2F572EdE7ADC926029',
    receiverPgpPubicKey: '',
  );

  final result = await send(options);

  print('testSend result = $result');
}
