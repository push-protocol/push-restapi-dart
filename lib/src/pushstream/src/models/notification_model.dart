// ignore_for_file: constant_identifier_names

const Map<String, int> NOTIFICATION_TYPE_MAP = {
  'BROADCAST': 1,
  'TARGETTED': 3,
  'SUBSET': 4,
};

class NotificationEvent {
  final String event;
  String origin;
  final String timestamp;
  final String from;
  final List<String> to;
  final String notifID;
  final NotificationChannel channel;
  final NotificationMeta meta;
  final NotificationMessage message;
  final NotificationConfig? config;
  final NotificationAdvanced? advanced;
  final String source;
  final NotificationRawData? raw;

  NotificationEvent({
    required this.event,
    required this.origin,
    required this.timestamp,
    required this.from,
    required this.to,
    required this.notifID,
    required this.channel,
    required this.meta,
    required this.message,
    this.config,
    this.advanced,
    required this.source,
    this.raw,
  });
}

class NotificationChannel {
  final String name;
  final String icon;
  final String url;

  NotificationChannel({
    required this.name,
    required this.icon,
    required this.url,
  });
}

class NotificationMeta {
  final String type;

  NotificationMeta({
    required this.type,
  });
}

class NotificationPayloadMeta {
  final String type;
  final String domain;
  final String data;

  NotificationPayloadMeta({
    required this.type,
    required this.domain,
    required this.data,
  });
}

class NotificationMessage {
  final NotificationContent notification;
  final NotificationPayload? payload;

  NotificationMessage({
    required this.notification,
    this.payload,
  });
}

class NotificationContent {
  final String title;
  final String body;

  NotificationContent({
    required this.title,
    required this.body,
  });
}

class NotificationPayload {
  final String? title;
  final String? body;
  final String? cta;
  final String? embed;
  final NotificationPayloadMeta? meta;

  NotificationPayload({
    this.title,
    this.body,
    this.cta,
    this.embed,
    this.meta,
  });
}

class NotificationConfig {
  final int? expiry;
  final bool? silent;
  final bool? hidden;

  NotificationConfig({
    this.expiry,
    this.silent,
    this.hidden,
  });
}

class NotificationAdvanced {
  final String? chatid;

  NotificationAdvanced({
    this.chatid,
  });
}

class NotificationRawData {
  final String verificationProof;

  NotificationRawData({
    required this.verificationProof,
  });
}

class NotificationEventType {
  static const INBOX = 'notification.inbox';
  static const SPAM = 'notification.spam';
}
