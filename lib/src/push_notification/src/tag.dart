import 'package:push_restapi_dart/src/channels/src/search_tags.dart';

import '../../../push_restapi_dart.dart';

class TagApi extends PushNotificationBaseClass {
  TagApi({
    required super.signer,
    required super.account,
    required super.guestMode,
    super.env,
  });

  Future<dynamic> get({required ChannelInfoOptions options}) async {
    try {
      checkSignerObjectExists();
      return getTags(channel: options.channel!, env: env);
    } catch (e) {
      log('Push SDK Error: API : tags::get : $e');
      rethrow;
    }
  }

  Future<dynamic> search(
      {required String query, int page = 1, int limit = 10}) async {
    return searchTags(query: query, page: page, limit: limit, env: env);
  }
}
