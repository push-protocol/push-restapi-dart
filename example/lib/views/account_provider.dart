import '../__lib.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

import 'package:ethers/signers/wallet.dart' as ether;

final accountProvider = ChangeNotifierProvider((ref) => AccountProvider(ref));

class AccountProvider extends ChangeNotifier {
  final Ref ref;

  AccountProvider(this.ref);

  Wallet? pushWallet;

  final mnemonic1 =
      'glory science timber unknown happy doctor walnut grain question float coffee trip';
  final mnemonic2 =
      'label mobile gas salt service gravity nose bomb marine online say twice';
  final mnemonic3 =
      'priority feed chair canoe news gym cost permit sea worry modify save';
  final mnemonic4 =
      'roast exclude blame mixture dune neither vital liquid winter summer nation solution';
  final mnemonic5 =
      'picnic crystal plug narrow siege need beach sphere radar wide ship trust';

  List<String> get accounts => [
        mnemonic2,
        mnemonic3,
        mnemonic4,
        mnemonic5,
        mnemonic1,
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
      ref.read(conversationsProvider).reset();
    } catch (e) {
      pop();
    }
  }

  Future<void> creatSocketConnection() async {
    try {
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
      // To get messages in realtime
      pushSDKSocket.on(EVENTS.CHAT_RECEIVED_MESSAGE, (message) {
        print('CHAT NOTIFICATION EVENTS.CHAT_RECEIVED_MESSAGE: $message');
        ref.read(conversationsProvider).onRecieveSocket(message);
      });

      // To get group creation or updation events
      pushSDKSocket.on(EVENTS.CHAT_GROUPS, (groupInfo) {
        print('CHAT NOTIFICATION EVENTS.CHAT_GROUPS: $groupInfo');
        final type = (groupInfo as Map<String, dynamic>)['eventType'];

        if (type == 'request') {
          ref.read(requestsProvider).addReqestFromSocket(
                Feeds(
                  chatId: groupInfo['chatId'],
                  intentSentBy: groupInfo['from'],
                ),
              );
          return;
        }
        ref.read(conversationsProvider).onRecieveSocket(groupInfo);
      });

      pushSDKSocket.on(
        EVENTS.SPACES_MESSAGES,
        (data) async {
          print(' NOTIFICATION EVENTS.SPACES_MESSAGES:r ${data['messageObj']}');

          final metaMessage = data as Map<String, dynamic>;

          if (metaMessage['messageCategory'] == 'Chat' &&
              metaMessage['messageType'] == 'Meta') {
            ref.read(PushSpaceProvider).onReceiveMetaMessage(metaMessage);
          }
        },
      );

      pushSDKSocket.on(
        EVENTS.DISCONNECT,
        (data) {
          print(' NOTIFICATION EVENTS.DISCONNECT: $data');
        },
      );
    } catch (e) {
      print(e);
    }
  }

  logOut() {
    pushWallet = null;
    notifyListeners();
  }
}
