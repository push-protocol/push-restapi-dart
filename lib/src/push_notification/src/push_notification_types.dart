// ignore_for_file: constant_identifier_names

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
