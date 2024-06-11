import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';
import 'package:ethers/signers/wallet.dart' as ether;

import '../../models/signer.dart';

runNotificationTest() async {
  log("runNotificationTest() started...");
  final signer1PK = dotenv.get('WALLET_PRIVATE_KEY');
  final signer2PK = dotenv.get('WALLET_PRIVATE_KEY_2');

  final ethersWallet1 = ether.Wallet.fromPrivateKey(signer1PK);

  final signer1 = EthersSigner(
    ethersWallet: ethersWallet1,
    address: ethersWallet1.address!,
  );

  final ethersWallet2 = ether.Wallet.fromPrivateKey(signer2PK);

  final signer2 = EthersSigner(
    ethersWallet: ethersWallet2,
    address: ethersWallet2.address!,
  );

  final userAlice = await PushAPI.initialize(
    signer: signer1,
    options: PushAPIInitializeOptions(env: ENV.staging),
  );
  final userKate = await PushAPI.initialize(
    signer: signer2,
    options: PushAPIInitializeOptions(
      env: ENV.staging,
      showHttpLog: true,
    ),
  );

  log('PushAPI.notification.subscribe');
  final subscribeResponse = await userAlice.notification.subscribe(
      channel:
          'eip155:11155111:0xD8634C39BBFd4033c0d3289C4515275102423681' // channel to subscribe
      );

  log(subscribeResponse);
  log('PushAPI.notification.subscribe | Response - 200 OK\n\n');
}
