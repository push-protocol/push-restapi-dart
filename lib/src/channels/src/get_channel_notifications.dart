// ignore_for_file: constant_identifier_names

import '../../../push_restapi_dart.dart';

class GetChannelNotificationOptions {
  String channel;
  ENV? env;
  int page;
  int limit;
  NotificationType? filter;
  bool? raw;

  GetChannelNotificationOptions({
    required this.channel,
    this.env,
    this.page = Pagination.INITIAL_PAGE,
    this.limit = Pagination.LIMIT_MAX,
    this.filter,
    this.raw,
  });
}

Future<dynamic> getChannelNotifications(
    GetChannelNotificationOptions options) async {
  final channel = await getCAIPAddress(address: options.channel);
  final query = getQueryParams(
    options.filter != null
        ? {
            "page": options.page,
            'limit': options.limit,
            'notificationType': options.filter?.value,
          }
        : {
            "page": options.page,
            'limit': options.limit,
          },
  );
  final requestUrl = '/$channel/notifications?$query';
  return http.get(
    path: requestUrl,
    baseUrl: Api.getAPIBaseUrls(options.env),
  );
}

enum NotificationType {
  BROADCAST,
  TARGETED,
  SUBSET,
}

extension NotificationTypeExtension on NotificationType {
  int get value {
    switch (this) {
      case NotificationType.BROADCAST:
        return 1;
      case NotificationType.TARGETED:
        return 3;
      case NotificationType.SUBSET:
        return 4;
    }
  }
}
