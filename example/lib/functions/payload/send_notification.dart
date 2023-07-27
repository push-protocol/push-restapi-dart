import 'dart:math';

import 'package:ethers/signers/wallet.dart' as ethers;
import 'package:push_restapi_dart/push_restapi_dart.dart' as push;
import 'package:web3dart/web3dart.dart' as web3;

import '../../__lib.dart';

void testSendNotificationFromChannel() async {}

void testSendVideoCallNotification() async {
  // 1. Create Random Wallet Signer
  final web3.Credentials randomCredentials =
      web3.EthPrivateKey.createRandom(Random.secure());
  final signer = Web3Signer(randomCredentials);

  // 2. Create Random Addresses
  final String randomAddress1 =
      Web3Signer(web3.EthPrivateKey.createRandom(Random.secure())).getAddress();
  final String randomAddress2 =
      Web3Signer(web3.EthPrivateKey.createRandom(Random.secure())).getAddress();

  // 3. Create a Push Profile for the signer
  await push.createUser(
    signer: signer,
    progressHook: (push.ProgressHookType progress) {
      print(progress.progressInfo);
    },
  );

  // 4. Create a Grp
  final result = await push.createGroup(
      signer: signer,
      groupName: "qwerty",
      groupDescription: "qwerty",
      groupImage: "Some Random Grp Image",
      members: [randomAddress1, randomAddress2],
      admins: [randomAddress1],
      isPublic: false);
}
