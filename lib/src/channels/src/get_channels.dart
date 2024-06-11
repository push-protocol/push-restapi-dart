import 'package:push_restapi_dart/push_restapi_dart.dart';

class GetChannelOptions {
  ENV? env;
  int page;
  int limit;

  String? sort;
  String? order;

  GetChannelOptions({
    this.env,
    this.page = Pagination.INITIAL_PAGE,
    this.limit = Pagination.LIMIT_MAX,
    this.order = ChannelListOrderType.DESCENDING,
    this.sort = ChannelListSortType.SUBSCRIBER,
  });
}

Future<dynamic> getChannels(GetChannelOptions options) async {
  final requestUrl = '/v1/channels?page=${options.page}'
      '&limit=${options.limit}&sort=${options.sort}&order=${options.order}';

  return http.get(
    path: requestUrl,
    baseUrl: Api.getAPIBaseUrls(options.env),
  );
}
