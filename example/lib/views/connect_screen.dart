import '../__lib.dart';

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
                  SizedBox(
                    height: 32,
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
