
import 'functions/chat/create_group.dart';
import "functions/chat/send.dart";
void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // // testFetchP2PChat();
  // testFetchChats();
  // // testCreatPushProfile();
  // testCreateGroup();
  testSend();
  // testApproveIntent();
  // // testFetchChats();
  // // testCreatPushProfile();
  testCreateGroup();

  // WidgetsFlutterBinding.ensureInitialized();

  // const mnemonic =
  //     'coconut slight random umbrella print verify agent disagree endorse october beyond bracket';
  // final ethersWallet = ether.Wallet.fromMnemonic(mnemonic);
  // final signer = EthersSigner(
  //   ethersWallet: ethersWallet,
  //   address: ethersWallet.address!,
  // );

  // print('walletMnemonic.address: ${ethersWallet.address}');
  // final user = await getUser(address: ethersWallet.address!);

  // if (user == null) {
  //   print('Cannot get user');
  //   return;
  // }

  // String? pgpPrivateKey = null;
  // if (user.encryptedPrivateKey != null) {
  //   pgpPrivateKey = await decryptPGPKey(
  //     encryptedPGPPrivateKey: user.encryptedPrivateKey!,
  //     wallet: getWallet(signer: signer),
  //   );
  // }

  // print('pgpPrivateKey: $pgpPrivateKey');

  // final pushWallet = Wallet(
  //   address: ethersWallet.address,
  //   signer: signer,
  //   pgpPrivateKey: pgpPrivateKey,
  // );

  // await initPush(
  //   wallet: pushWallet,
  //   env: ENV.staging,
  // );

  // testSend();

  // runApp(
  //   MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     title: 'Push',
  //     theme: ThemeData(
  //       primarySwatch: Colors.purple,
  //     ),
  //     home: HomeScreen(),
  //   ),
  // );
}
