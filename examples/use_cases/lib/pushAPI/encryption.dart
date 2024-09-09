import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';
import 'package:ethers/signers/wallet.dart' as ether;

import '../../models/signer.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runEncryptionTest();
}

//'PushAPI.encryption functionality'
runEncryptionTest() async {
  log("runNotificationTest() started...");
  final signer1PK = dotenv.get('WALLET_PRIVATE_KEY');

  final ethersWallet1 = ether.Wallet.fromPrivateKey(signer1PK);

  final signer1 = EthersSigner(
    ethersWallet: ethersWallet1,
    address: ethersWallet1.address!,
  );

  final userAlice = await PushAPI.initialize(
    signer: signer1,
    options: PushAPIInitializeOptions(env: ENV.staging),
  );

  final response = await userAlice.encryption.info();

  final data = response as Map<String, dynamic>;
  if ((data['decryptedPgpPrivateKey'] as String)
      .contains('-----BEGIN PGP PRIVATE KEY BLOCK-----\n')) {
    log('decryptedPgpPrivateKey has -----BEGIN PGP PRIVATE KEY BLOCK-----\n');
  }
  if ((data['pgpPublicKey'] as String)
      .contains('-----BEGIN PGP PUBLIC KEY BLOCK-----\n')) {
    log('pgpPublicKey has-----BEGIN PGP PUBLIC KEY BLOCK-----\n');
  }
}
