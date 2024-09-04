import '../../../push_restapi_dart.dart';

Future<dynamic> searchTags({
  required String query,
  int page = 1,
  int limit = 10,
  ENV? env,
}) async {
  final queryObj = {
    'page': page,
    'limit': limit,
    'query': query,
  };
  var apiEndpoint = '/v1/channels/search/tags?${getQueryParams(queryObj)}';
  return http.get(
    path: apiEndpoint,
    baseUrl: Api.getAPIBaseUrls(env),
  );
}
