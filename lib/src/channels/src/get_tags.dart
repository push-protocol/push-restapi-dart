import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<dynamic> getTags({required String channel, required ENV env}) async {
  final c = await getCAIPAddress(address: channel);
  return http.get(
    path: '/v1/channels/$c/tags',
    baseUrl: Api.getAPIBaseUrls(env),
  );
}
