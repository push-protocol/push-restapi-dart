import 'package:push_restapi_dart/push_restapi_dart.dart' as push;

import 'package:ethers/signers/wallet.dart' as ether;

import '../../models/signer.dart';

testStartSpace( String spaceId) {
  final ethersWallet = ether.Wallet.fromPrivateKey(
      "c41b72d56258e50595baa969eb0949c5cee9926ac55f7bad21fe327236772e0c");

  final signer = EthersSigner(
    ethersWallet: ethersWallet,
    address: ethersWallet.address!,
  );

  push.startSpace(
    signer: signer,
    spaceId: spaceId,
    // spaceId: 'spaces:118a0710ea84fd48ebb1869bd6b882ad1d937ce6f6103bd231a34865357cc0a7',
    livepeerApiKey: '4217cd75-ce67-49af-a6dd-aa1581f7d651',
    progressHook: (p0) {},
  );
}
