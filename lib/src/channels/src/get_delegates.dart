import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<dynamic> getDelegates({
  required String channel,
  ENV? env,
}) async {
  final channelAddress = await getCAIPAddress(address: channel);
  final requestUrl = '/v1/channels/$channelAddress/delegates';
  return http.get(
    path: requestUrl,
    baseUrl: Api.getAPIBaseUrls(env),
  );
}
