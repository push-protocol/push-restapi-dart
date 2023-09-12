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
  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(accountProvider);
    final accounts = vm.accounts;
    final actions = vm.actions;
    Wallet? pushWallet = vm.pushWallet;
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
                    )
                  else
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
            // if (isLoading)
            //   Positioned.fill(
            //     child: Container(
            //       color: Colors.black.withOpacity(.15),
            //       child: Center(child: CircularProgressIndicator()),
            //     ),
            //   )
          ],
        ),
      ),
    );
  }
}

pop() {
  Navigator.pop(Get.context!);
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
