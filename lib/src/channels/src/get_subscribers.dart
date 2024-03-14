import '../../../push_restapi_dart.dart';

class GetChannelSubscribersOptionsType {
  String channel; // plain ETH Format only
  int page;
  int limit;
  int? category;
  bool? setting;
  ENV? env;
  bool? raw;

  GetChannelSubscribersOptionsType({
    required this.channel,
    this.page = 1,
    this.limit = 10,
    this.category,
    this.setting,
    this.env,
    this.raw,
  });
}

Future<dynamic> getSubscribers(GetChannelSubscribersOptionsType options) async {
  try {
    if (options.channel.isEmpty) {
      throw Exception('channel cannot be null or empty');
    }

    if (options.page <= 0) {
      throw Exception('page must be greater than 0');
    }

    if (options.limit <= 0) {
      throw Exception('limit must be greater than 0');
    }
    if (options.limit > 30) {
      throw Exception('limit must be lesser than or equal to 30');
    }

    final channelAddress = await getCAIPAddress(address: options.channel);
    var apiEndpoint =
        '/v1/channels/$channelAddress/subscribers?page=${options.page}'
        '&limit=${options.limit}&setting=${options.setting}';
    if (options.category != null) {
      apiEndpoint = 'apiEndpoint&category=${options.category}';
    }

    return http.get(
      path: apiEndpoint,
      baseUrl: Api.getAPIBaseUrls(options.env),
    );
  } catch (e) {
    log('[Push SDK] - API  - Error - API send() -:  $e');
    rethrow;
  }
}
