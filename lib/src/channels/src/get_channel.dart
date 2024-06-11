import '../../../push_restapi_dart.dart';

Future<dynamic> getChannel({
  required String channel,
  ENV? env,
}) async {
  try {
    final channelAddress = await getCAIPAddress(address: channel);
    final result = await http.get(
      path: '/v1/channels/$channelAddress',
      baseUrl: Api.getAPIBaseUrls(env),
    );
    return result;
  } catch (e) {
    log('[Push SDK] - API getChannel:  $e');
  }
}
