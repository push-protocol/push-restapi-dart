import 'package:example/models/signer.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

import 'package:ethers/signers/wallet.dart' as ether;

void testSendToGroup() async {
  final ethersWallet = ether.Wallet.fromPrivateKey(
      "c41b72d56258e50595baa969eb0949c5cee9926ac55f7bad21fe327236772e0c");

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

  final options = ChatSendOptions(
    accountAddress: ethersWallet.address,
    pgpPrivateKey: pgpPrivateKey,
    messageContent: 'Hey again!!!!!7',
    receiverAddress:
        '00a886257fd96028f3131c77a2fb11b702bd05465fd19479b9024643167e99e6',
    // receiverPgpPubicKey: '',
  );

  final result = await send(options);

  print('testSend result = $result');
}
