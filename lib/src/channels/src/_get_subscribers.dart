import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<List<String>?> getSubscribers(
    {required String channel, ENV? env}) async {
  final channelAddress = await getCAIPAddress(address: channel);
  final channelCAIPDetails = getCAIPDetails(channelAddress);
  if (channelCAIPDetails == null) {
    throw Exception('Invalid Channel CAIP!');
  }

  final chainId = channelCAIPDetails.networkId;
  final body = {
    'channel':
        channelCAIPDetails.address, // deprecated API expects ETH address format
    'blockchain': chainId,
    'op': 'read',
  };

  final result = await http.post(
    path: '/channels/_get_subscribers',
    data: body,
    baseUrl: Api.getAPIBaseUrls(env),
  );

  return result['subscribers'];
}
