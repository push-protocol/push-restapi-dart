import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';
import 'package:ethers/signers/wallet.dart' as ether;
import 'package:web3dart/web3dart.dart' as web3;
import '../../models/signer.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runEncryptionUpdateTest();
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

runEncryptionUpdateTest() async {
  log("runNotificationTest() started...");

  var random = Random.secure();
  final wallet = web3.EthPrivateKey.createRandom(random);

  // final ethersWallet1 = ether.Wallet.fromPrivateKey(wallet.privateKey);

  final signer1 = Web3Signer(wallet);

  final userAlice = await PushAPI.initialize(
    signer: signer1,
    options: PushAPIInitializeOptions(env: ENV.staging),
  );

  await userAlice.encryption
      .update(updatedEncryptionType: EncryptionType.PGP_V3);

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
