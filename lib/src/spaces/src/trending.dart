import 'package:push_restapi_dart/push_restapi_dart.dart';

///page index - default 1
///limit: no of items per page - default 10 - max 30
Future<List<SpaceFeeds>?> trending({
  int page = 1,
  int limit = 10,
}) async {
  try {
    final result = await http.get(
      path: '/v1/spaces/trending?page=$page&limit=$limit',
    );

    if (result == null || result['spaces'] == null) {
      return null;
    }

    final requestList =
        (result['spaces'] as List).map((e) => SpaceFeeds.fromJson(e)).toList();
    final feedWithInbox = await getTrendingSpaceInboxList(
      feedsList: requestList,
    );

    return feedWithInbox;
  } catch (e) {
    log(e);
    throw Exception('[Push SDK] - API requests: $e');
  }
}
