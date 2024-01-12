import '../../../__lib.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

final conversationsProvider =
    ChangeNotifierProvider((ref) => ConversationsProvider(ref));

class ConversationsProvider extends ChangeNotifier {
  final Ref ref;
  ConversationsProvider(this.ref);

  bool isBusy = false;
  setBusy(bool state) {
    isBusy = state;
    notifyListeners();
  }

  List<Feeds> _conversations = [];
  List<Feeds> get conversations => _conversations;

  String get localAddress => ref.read(accountProvider).pushUser!.account;
  PushAPI get pushUser => ref.read(accountProvider).pushUser!;

  Future loadChats() async {
    setBusy(true);
    final result = await pushUser.chat.list(
      type: ChatListType.CHATS,
      limit: 20,
    );

    if (result != null) {
      _conversations = result;

      notifyListeners();
    }
    setBusy(false);
  }

  reset() {
    _conversations = [];
    notifyListeners();
    loadChats();
  }

  onReceiveSocket(dynamic message) {
    try {
      loadChats();

      final chatId = (message as Map<String, dynamic>)['chatId'];
      final currentChatid = ref.read(chatRoomProvider).currentChatId;
      if (chatId == currentChatid) {
        ref.read(chatRoomProvider).onRefreshRoom();
      }
    } catch (e) {
      print(e);
    }
  }
}
