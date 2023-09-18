import 'package:example/__lib.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

import 'package:ethers/signers/wallet.dart' as ether;

final accountProvider = ChangeNotifierProvider((ref) => AccountProvider(ref));

class AccountProvider extends ChangeNotifier {
  final Ref ref;

  AccountProvider(this.ref);

  Wallet? pushWallet;

  // final mnemonic1 =
  //     'coconut slight random umbrella print verify agent disagree endorse october beyond bracket';
  final mnemonic2 =
      'label mobile gas salt service gravity nose bomb marine online say twice';
  final mnemonic3 =
      'priority feed chair canoe news gym cost permit sea worry modify save';
  final mnemonic4 =
      'roast exclude blame mixture dune neither vital liquid winter summer nation solution';
  final mnemonic5 =
      'picnic crystal plug narrow siege need beach sphere radar wide ship trust';

  List<String> get accounts => [
        // mnemonic1,
        mnemonic2,
        mnemonic3,
        mnemonic4,
        mnemonic5,
      ];

  List<NavItem> get spaceActions => [
        NavItem(
          title: 'Create Space',
          onPressed: () {
            pushScreen(
              CreateSpaceScreen(),
            );
          },
        ),
        NavItem(
          title: 'My Spaces',
          onPressed: () {
            pushScreen(
              MySpacesScreen(),
            );
          },
        ),
        NavItem(
          title: 'Trending Spaces',
          onPressed: () {
            pushScreen(
              TrendingSpaceScreen(),
            );
          },
        ),
      ];

  List<NavItem> get chatActions => [
        NavItem(
          title: 'Create Group',
          onPressed: () {
            pushScreen(
              CreateGroupScreen(),
            );
          },
        ),
        NavItem(
          title: 'Conversations',
          onPressed: () {
            pushScreen(
              ConversationsScreen(),
            );
          },
        ),
        NavItem(
          title: 'Pending Requests',
          onPressed: () {
            pushScreen(
              ChatRequestScreen(),
            );
          },
        ),
      ];
  connectWallet(String mnemonic) async {
    try {
      showLoadingDialog();
      final ethersWallet = ether.Wallet.fromMnemonic(mnemonic);
      final signer = EthersSigner(
        ethersWallet: ethersWallet,
        address: ethersWallet.address!,
      );

      print('walletMnemonic.address: ${ethersWallet.address}');
      final user = await getUser(address: ethersWallet.address!);

      if (user == null) {
        pop();
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
      notifyListeners();

      pop();

      initPush(
        wallet: pushWallet,
        env: ENV.staging,
      );
      creatSocketConnection();
    } catch (e) {
      pop();
    }
  }

  Future<void> creatSocketConnection() async {
    final options = SocketInputOptions(
      user: pushWallet!.address!,
      env: ENV.staging,
      socketType: SOCKETTYPES.CHAT,
      socketOptions: SocketOptions(
        autoConnect: true,
        reconnectionAttempts: 3,
      ),
    );

    final pushSDKSocket = await createSocketConnection(options);
    if (pushSDKSocket == null) {
      throw Exception('PushSDKSocket Connection Failed');
    }

    pushSDKSocket.connect();

    pushSDKSocket.on(
      EVENTS.CONNECT,
      (data) async {
        print(' NOTIFICATION EVENTS.CONNECT: $data');
      },
    );
    // Listening Feeds ( Notifications received by user )
    pushSDKSocket.on(
      EVENTS.USER_FEEDS,
      (data) {
        print(' EVENTS.USER_FEEDS: $data');
      },
    );
    // Listening Spam Feeds ( Spam Notifications received by user )
    pushSDKSocket.on(
      EVENTS.USER_SPAM_FEEDS,
      (data) {
        print(' EVENTS.USER_SPAM_FEEDS: $data');
      },
    );
    pushSDKSocket.on(
      EVENTS.DISCONNECT,
      (data) {
        print(' NOTIFICATION EVENTS.DISCONNECT: $data');
      },
    );
  }

  logOut() {
    pushWallet = null;
    notifyListeners();
  }
}
