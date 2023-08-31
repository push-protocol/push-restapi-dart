import 'package:example/views/my_spaces_screen.dart';
import 'package:example/views/trending_space_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

import 'package:ethers/signers/wallet.dart' as ether;
import '../__lib.dart';
import 'create_space_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Wallet? pushWallet;

  bool isLoading = false;
  updateLoading(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  final mnemonic1 =
      'coconut slight random umbrella print verify agent disagree endorse october beyond bracket';
  final mnemonic2 =
      'label mobile gas salt service gravity nose bomb marine online say twice';
  connectWallet(String mnemonic) async {
    updateLoading(true);
    final ethersWallet = ether.Wallet.fromMnemonic(mnemonic);
    final signer = EthersSigner(
      ethersWallet: ethersWallet,
      address: ethersWallet.address!,
    );

    print('walletMnemonic.address: ${ethersWallet.address}');
    final user = await getUser(address: ethersWallet.address!);

    if (user == null) {
      updateLoading(false);
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

    updateLoading(false);

    initPush(
      wallet: pushWallet,
      env: ENV.staging,
    );
  }

  connectWallet3() async {
    updateLoading(true);
    final ethersWallet = ether.Wallet.fromPrivateKey(
        "c41b72d56258e50595baa969eb0949c5cee9926ac55f7bad21fe327236772e0c");

    final signer = EthersSigner(
      ethersWallet: ethersWallet,
      address: ethersWallet.address!,
    );

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

    pushWallet = Wallet(
        address: ethersWallet.address!,
        pgpPrivateKey: pgpPrivateKey,
        signer: signer);

    updateLoading(false);
    await initPush(
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
      ref.read(PushVideoCallProvider.notifier).create(optiions);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final actions = [
      NavItem(
        title: 'Create Space',
        onPressed: () {
          pushScreen(
            context,
            CreateSpaceScreen(),
          );
        },
      ),
      NavItem(
        title: 'My Spaces',
        onPressed: () {
          pushScreen(
            context,
            MySpacesScreen(),
          );
        },
      ),
      NavItem(
        title: 'Trending Spaces',
        onPressed: () {
          pushScreen(
            context,
            TrendingSpaceScreen(),
          );
        },
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Align(
                      alignment: Alignment.topCenter,
                      child: SvgPicture.asset(AppAssets.ASSETS_PUSHLOGO_SVG)),
                  SizedBox(height: 64),
                  if (pushWallet == null)
                    Wrap(
                      children: [
                        MaterialButton(
                          color: Colors.white,
                          child: Text(
                            'Connect Wallet 1',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            connectWallet(mnemonic1);
                          },
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        MaterialButton(
                          color: Colors.white,
                          child: Text(
                            'Connect Wallet 2',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            connectWallet(mnemonic2);
                          },
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        MaterialButton(
                          color: Colors.white,
                          child: Text(
                            'Connect Wallet 3',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            connectWallet3();
                          },
                        ),
                      ],
                    )
                  else
                    Expanded(
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              'Address: \n${pushWallet?.address}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: ListView.separated(
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
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(.15),
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
          ],
        ),
      ),
    );
  }
}

pushScreen(BuildContext context, Widget screen) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ));
}

class NavItem {
  final String title;
  final Function() onPressed;

  NavItem({
    required this.title,
    required this.onPressed,
  });
}
