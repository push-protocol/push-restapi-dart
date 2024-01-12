import 'package:blockies/blockies.dart';

import '../__lib.dart';

class ConnectScreen extends ConsumerWidget {
  const ConnectScreen({
    super.key,
    required this.accounts,
    required this.vm,
  });

  final List<DemoUser> accounts;
  final AccountProvider vm;

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
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
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        final item = accounts[index];
                        return InkWell(
                          onTap: () {
                            vm.connectWallet(item);
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                border: Border.all(color: pushColor),
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Blockies(seed: item.address),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: KText(
                                    item.address,
                                    size: 16,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16),
                      itemCount: accounts.length,
                    ),
                  ),
                  MaterialButton(
                    color: pushColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    onPressed: () {
                      ref.read(accountProvider).generateNewUser();
                    },
                    textColor: Colors.white,
                    child: Center(child: Text('Add New Wallet')),
                    padding: EdgeInsets.all(16),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
