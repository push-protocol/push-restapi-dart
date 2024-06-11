import '../../../push_restapi_dart.dart';

getSubscriptions({
  required String address,
  String? channel,
}) async {
  final query = channel == null
      ? ''
      : getQueryParams({
          'channel': channel,
        });
  final user = await getCAIPAddress(address: address);
  return await http.get(path: '/v1/users/$user/subscriptions?$query');
}
