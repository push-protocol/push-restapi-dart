import '../../../__lib.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

final requestsProvider = ChangeNotifierProvider((ref) => RequestsProvider(ref));

class RequestsProvider extends ChangeNotifier {
  final Ref ref;
  RequestsProvider(this.ref);

  List<Feeds>? _requests;
  List<Feeds>? get requestsList => _requests;

  bool isBusy = false;
  setBusy(bool state) {
    isBusy = state;
    notifyListeners();
  }

  PushAPI get pushUser => ref.read(accountProvider).pushUser!;

  Future loadRequests() async {
    setBusy(true);
    _requests = await pushUser.chat.list(type: ChatListType.REQUESTS);

    setBusy(false);
  }

  addReqestFromSocket(Feeds req) {
    loadRequests();
    // if (_requests != null) {
    //   _requests!.insert(0, req);
    // } else {
    //   _requests = [req];
    // }
    // notifyListeners();
  }
}
