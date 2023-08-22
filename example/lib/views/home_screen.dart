import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

import 'package:ethers/signers/wallet.dart' as ether;
import '../__lib.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Wallet? pushWallet;

  connectWallet() async {
    const mnemonic =
        'coconut slight random umbrella print verify agent disagree endorse october beyond bracket';
    final ethersWallet = ether.Wallet.fromMnemonic(mnemonic);
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

    pushWallet = Wallet(
      address: ethersWallet.address,
      signer: signer,
      pgpPrivateKey: pgpPrivateKey,
    );

    setState(() {});

    initPush(
      wallet: pushWallet,
      env: ENV.staging,
    );
  }

  requestPermissions() {
    Permission.camera.request();
  }

  onVideo() {
    // final VideoCallData video = ref.read(videoCallStateProvider).videoCallData;
    try {
      final optiions = VideoCreateInputOptions();
      ref.read(videoCallStateProvider.notifier).create(optiions);
    } catch (e) {}
  }

  final actions = [
    NavItem(
      title: 'Chats',
      onPressed: () {},
    ),
    NavItem(
      title: 'User',
      onPressed: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16),
            Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(AppAssets.ASSETS_PUSHLOGO_SVG)),
            SizedBox(height: 64),
            if (pushWallet == null)
              MaterialButton(
                color: Colors.white,
                child: Text(
                  'Connect Wallet',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: connectWallet,
              )
            else
              Text(
                'Address: ${pushWallet?.address}',
                style: TextStyle(color: Colors.white),
              ),
            SizedBox(height: 16),
            MaterialButton(
              color: Colors.white,
              child: Text(
                'Video Button',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: onVideo,
            ),
            SizedBox(height: 16),
            if (pushWallet != null)
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: actions.length,
                  itemBuilder: (context, index) {
                    final item = actions[index];
                    return ListTile(
                      tileColor: Colors.white,
                      title: Text(item.title),
                      onTap: item.onPressed,
                      trailing: Icon(Icons.arrow_forward_ios),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NavItem {
  final String title;
  final Function() onPressed;

  NavItem({
    required this.title,
    required this.onPressed,
  });
}
