import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

final mySpacesProvider =
    StateNotifierProvider<MySpacesProvider, List<SpaceFeeds>>(
        (ref) => MySpacesProvider([]));

class MySpacesProvider extends StateNotifier<List<SpaceFeeds>> {
  MySpacesProvider(super.state);

  Future onRefresh() async {
    final result = await spaceFeeds(toDecrypt: true, limit: 5);
    if (result != null) {
      state = result;
    }
  }
}
