import '../../../__lib.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

final spaceRequestsProvider =
    ChangeNotifierProvider((ref) => SpaceRequestsProvider(ref));

class SpaceRequestsProvider extends ChangeNotifier {
  final Ref ref;
  SpaceRequestsProvider(this.ref);

  List<SpaceFeeds>? _requests;
  List<SpaceFeeds>? get requestsList => _requests;

  bool isBusy = false;
  setBusy(bool state) {
    isBusy = state;
    notifyListeners();
  }

  loadRequests() async {
    setBusy(true);
    _requests = await spaceRequests(
      toDecrypt: true,
    );

    setBusy(false);
  }

  addReqestFromSocket(SpaceFeeds req) {
    if (_requests != null) {
      _requests!.insert(0, req);
    } else {
      _requests = [req];
    }
    notifyListeners();
  }
}
