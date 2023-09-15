import 'package:clipboard/clipboard.dart';
import 'package:example/views/account_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

import '../__lib.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(accountProvider);
    final accounts = vm.accounts;
    final actions = currentIndex == 0 ? vm.spaceActions : vm.chatActions;
    Wallet? pushWallet = vm.pushWallet;
    return pushWallet == null
        ? ConnectScreen(accounts: accounts, vm: vm)
        : Scaffold(
            backgroundColor: Colors.purpleAccent,
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: currentIndex,
                selectedItemColor: Colors.purpleAccent,
                onTap: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.multitrack_audio_outlined),
                      label: 'Spaces'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.forum), label: 'Chat')
                ]),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.topCenter,
                      child: SvgPicture.asset(AppAssets.ASSETS_PUSHLOGO_SVG),
                    ),
                    SizedBox(height: 64),
                    Expanded(
                      child: Column(
                        children: [
                          DataView(
                            color: Colors.white,
                            label: 'Address: ',
                            value: pushWallet.address ?? '',
                          ),
                          SizedBox(height: 16),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () {
                                FlutterClipboard.copy(pushWallet.address!)
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
            ),
          );
  }
}

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({
    super.key,
    required this.accounts,
    required this.vm,
  });

  final List<String> accounts;
  final AccountProvider vm;

  @override
  Widget build(BuildContext context) {
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
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: List.generate(
                      accounts.length,
                      (index) => InkWell(
                        onTap: () {
                          vm.connectWallet(accounts[index]);
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
                  ),
                  SizedBox(height: 32,),
                  InkWell(
                    onTap: () {
                      vm.connectWallet3();
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
                          Text('User alt'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

pop([BuildContext? context]) {
  Navigator.pop(context ?? Get.context!);
}

pushScreen(Widget screen) {
  Navigator.push(
      Get.context!,
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
