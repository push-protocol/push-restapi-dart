import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

import 'dart:math' as m;

import '../../../__lib.dart';

final liveSpaceProvider = ChangeNotifierProvider<LiveSpaceProvider>((ref) {
  return LiveSpaceProvider();
});

class LiveSpaceProvider extends PushSpaceNotifier {
  get random => m.Random();
  get tween => Tween<Offset>(
        begin: Offset(random.nextDouble() * .5, random.nextDouble()),
        end: Offset(0, (random.nextDouble() * -1) - 1),
      ).chain(CurveTween(curve: Curves.linear));

  List<String> reactions = [];

  onRecieveReaction(String reaction, String from) {
    reactions.insert(0, '$from   $reaction');

    notifyListeners();

    Future.delayed(
      Duration(seconds: 4),
      () {
        if (reactions.isNotEmpty) {
          reactions.removeLast();
        }

        notifyListeners();
      },
    );
  }
}
