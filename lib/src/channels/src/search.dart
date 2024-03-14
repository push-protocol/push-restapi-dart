import '../../../push_restapi_dart.dart';

Future<dynamic> search({
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
  var apiEndpoint = '/v1/channels/search/?${getQueryParams(queryObj)}';
  return http.get(
    path: apiEndpoint,
    baseUrl: Api.getAPIBaseUrls(env),
  );
}
