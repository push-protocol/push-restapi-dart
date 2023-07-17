import 'package:example/models/signer.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

import 'package:ethers/signers/wallet.dart' as ethers;

void testSend() async {
  const mnemonic =
      'coconut slight random umbrella print verify agent disagree endorse october beyond bracket';
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
    messageContent: 'this is a message',
    receiverAddress: '0x9960D6B63B113303B9910A03ca5341B83CC52723',
    receiverPgpPubicKey: '',
  );

  final result = await send(options);

  print('testSend result = $result');
}
