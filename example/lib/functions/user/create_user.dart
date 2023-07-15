import 'package:ethers/signers/wallet.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart' as push;

import '../../models/signer.dart';

void testCreateUser() async {
  const mnemonic =
      'wink cancel juice stem alert gesture rally pupil evidence top night fury';
  final ethersWallet = Wallet.fromMnemonic(mnemonic);
  final w = SignerPrivateKey(
    ethersWallet: ethersWallet,
    address: ethersWallet.address!,
  );

  try {
    final result = await push.createUser(
      signer: w,
      progressHook: (push.ProgressHookType progress) {
        print(progress.progressInfo);
      },
    );

    print(result);
  } catch (e) {
    print(e);
  }
}
