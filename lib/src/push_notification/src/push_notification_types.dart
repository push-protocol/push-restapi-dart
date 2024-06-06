// ignore_for_file: constant_identifier_names

import '../../../push_restapi_dart.dart';

class UserSetting {
  bool enabled;
  dynamic value; // Can be a number or a range object

  UserSetting({required this.enabled, this.value});
}

class NotificationSetting {
  final int type;
  final dynamic defaultVal;
  final String description;
  final Map<String, int>? data;

  NotificationSetting({
    required this.type,
    required this.defaultVal,
    required this.description,
    this.data,
  });
}

class ChannelListOrderType {
  static const String ASCENDING = 'asc';
  static const String DESCENDING = 'desc';
}

class ChannelListSortType {
  static const String SUBSCRIBER = 'subscribers';
}

class ChannelInfoOptions {
  String? channel;
  int? page;
  int? limit;
  int? category;
  bool? setting;
  bool? raw;

  ChannelInfoOptions({
    this.channel,
    this.page,
    this.limit,
    this.category,
    this.setting,
    this.raw,
  });
}

class FeedsOptions {
  String? account;
  List<String>? channels;
  int page;
  int limit;
  bool? raw;

  FeedsOptions({
    this.account,
    this.channels,
    this.page = Pagination.INITIAL_PAGE,
    this.limit = Pagination.LIMIT,
    this.raw,
  });
}

enum FeedType {
  INBOX,
  SPAM,
}

extension FeedTypeExtension on FeedType {
  String get value {
    switch (this) {
      case FeedType.INBOX:
        return 'INBOX';
      case FeedType.SPAM:
        return 'SPAM';
    }
  }
}

class SubscriptionOptions {
  String? account;
  int page;
  int limit;
  String? channel;
  bool? raw;

  SubscriptionOptions({
    this.account,
    this.page = Pagination.INITIAL_PAGE,
    this.limit = Pagination.LIMIT,
    this.channel,
    this.raw,
  });
}

class SubscribeUnsubscribeOptions {
  Function()? onSuccess;
  Function(Exception)? onError;
  List<UserSetting>? settings;

  SubscribeUnsubscribeOptions({this.onSuccess, this.onError, this.settings});
}
