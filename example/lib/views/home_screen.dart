import 'package:clipboard/clipboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final mnemonic3 =
      'priority feed chair canoe news gym cost permit sea worry modify save';
  final mnemonic4 =
      'roast exclude blame mixture dune neither vital liquid winter summer nation solution';
  final mnemonic5 =
      'picnic crystal plug narrow siege need beach sphere radar wide ship trust';

  connectWallet(String mnemonic) async {
    try {
      showLoadingDialog(context);
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
      setState(() {});

      Navigator.pop(context);

      initPush(
        wallet: pushWallet,
        env: ENV.staging,
      );
    } catch (e) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = [
      mnemonic1,
      mnemonic2,
      mnemonic3,
      mnemonic4,
      mnemonic5,
    ];
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
                      spacing: 24,
                      runSpacing: 24,
                      children: List.generate(
                        accounts.length,
                        (index) => InkWell(
                          onTap: () {
                            connectWallet(accounts[index]);
                          },
                          child: Container(
                            padding: EdgeInsets.all(24),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person_4_rounded,
                                  size: 32,
                                ),
                                Text('User ${index + 1}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: Column(
                        children: [
                          DataView(
                            color: Colors.white,
                            label: 'Address: ',
                            value: pushWallet?.address ?? '',
                          ),
                          SizedBox(height: 16),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () {
                                FlutterClipboard.copy(pushWallet!.address!)
                                    .then((value) {
                                  showMyDialog(
                                      context: context,
                                      title: 'Address ',
                                      message: 'address copied successfully');
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.copy,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Copy Address',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
