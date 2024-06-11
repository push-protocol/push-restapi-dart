import '../../../push_restapi_dart.dart';

class FeedsPerChannelOptions {
  String user;
  ENV? env;
  List<String>? channels;
  int? page;
  int? limit;
  bool? spam;
  bool? raw;

  FeedsPerChannelOptions({
    required this.user,
    this.env,
    this.channels,
    this.page,
    this.limit,
    this.spam,
    this.raw,
  });
}

Future<dynamic> getFeedsPerChannel(
    {required FeedsPerChannelOptions options}) async {
  final user = await getCAIPAddress(address: options.user);
  final channels = options.channels ?? [];
  if (channels.isEmpty) {
    throw Exception('channels cannot be empty');
  }

  final channel = await getCAIPAddress(address: channels.first);
  final query = getQueryParams({
    'page': options.page ?? '',
    'limit': options.limit ?? '',
    'spam': options.spam ?? ''
  });
  return http.get(
    path: '/v1/users/$user/channels/$channel/feeds?$query',
  );
}
