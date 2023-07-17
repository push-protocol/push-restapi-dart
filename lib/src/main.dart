import '../push_restapi_dart.dart';

Future initPush({ENV env = ENV.staging, Wallet? wallet}) async {
  providerContainer.read(envProvider.notifier).setEnv(env);

  if (wallet != null) {
    await providerContainer
        .read(userEthWalletProvider.notifier)
        .setCurrentUserEthWallet(wallet);
  }
}
