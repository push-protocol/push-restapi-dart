import 'package:push_restapi_dart/push_restapi_dart.dart' as push;

void testSpaceFeeds() async {
  final result = await push.spaceFeeds(
    
  );

  print(result);
  if (result is List<push.SpaceFeeds>) {
    
  }
}
