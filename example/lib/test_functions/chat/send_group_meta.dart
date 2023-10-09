import 'package:example/models/signer.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

import 'package:ethers/signers/wallet.dart' as ethers;

Future<void> testSendToGroupMeta() async {
  final ethersWallet = ethers.Wallet.fromMnemonic(
      'label mobile gas salt service gravity nose bomb marine online say twice');

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
    message: MetaMessage(
        action: META_ACTION.CREATE_SPACE,
        info: Info(
            affected: [ethersWallet.address!], arbitrary: {'key': 'value'}),
        content: "PUSH SPACE META MESSAGE"),
    receiverAddress:
        '60d2bbcb9e2f75651f33e0d2b4930a1bbd8aa36a55f9af41639e8340b8cf6d37',
  );

  final result = await send(options);

  print('testSend result = $result');
}
