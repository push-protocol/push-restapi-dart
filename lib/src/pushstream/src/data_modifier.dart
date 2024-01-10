import '../../../push_restapi_dart.dart';

class DataModifier {
  static Future<dynamic> handleChatGroupEvent(
      {required dynamic data, bool includeRaw = false}) async {
    switch (data['eventType']) {
      case 'create':
        break;
      default:
    }
  }

  static ProposedEventNames convertToProposedName(String currentEventName) {
    switch (currentEventName) {
      case 'message':
        return ProposedEventNames.Message;
      case 'request':
        return ProposedEventNames.Request;
      case 'accept':
        return ProposedEventNames.Accept;
      case 'reject':
        return ProposedEventNames.Reject;
      case 'leaveGroup':
        return ProposedEventNames.LeaveGroup;
      case 'joinGroup':
        return ProposedEventNames.JoinGroup;
      case 'createGroup':
        return ProposedEventNames.CreateGroup;
      case 'updateGroup':
        return ProposedEventNames.UpdateGroup;
      case 'remove':
        return ProposedEventNames.Remove;
      default:
        throw Exception('Unknown current event name: $currentEventName');
    }
  }

  static handleToField(dynamic data) {
    switch (data.event) {
      case ProposedEventNames.LeaveGroup:
      case ProposedEventNames.JoinGroup:
        data.to = null;
        break;

      case ProposedEventNames.Accept:
      case ProposedEventNames.Reject:
        if (data['meta']?['group'] != null) {
          data.to = null;
        }
        break;

      default:
        break;
    }
  }

  static handleChatEvent(dynamic data, [includeRaw = false]) async {
    if (data == null) {
      log('Error in handleChatEvent: data is undefined or null');
      throw Exception('data is undefined or null');
    }

    final eventTypeMap = {
      'Chat': MessageEventType.message,
      'Request': MessageEventType.request,
      'Approve': MessageEventType.accept,
      'Reject': MessageEventType.reject,
    };

    final key = data['eventType'] ?? data['messageCategory'];

    if (!eventTypeMap.containsKey(key)) {
      throw FormatException('Invalid eventType or messageCategory in data');
    }

    final eventType = eventTypeMap[key];

    if (eventType != null) {
      return mapToMessageEvent(data, includeRaw, eventType);
    } else {
      log('Unknown eventType: ${data['eventType'] ?? data['messageCategory']}');
      return data;
    }
  }

  static MessageEvent mapToMessageEvent(
    Map<String, dynamic> data,
    bool includeRaw,
    String eventType,
  ) {
    final messageEvent = MessageEvent(
      event: eventType,
      origin: data['messageOrigin'],
      timestamp: data['timestamp'].toString(),
      chatId: data['chatId'],
      from: data['fromCAIP10'],
      to: [data['toCAIP10']],
      message: MessageContent(
        type: data['messageType'],
        content: data['messageContent'],
      ),
      meta: MessageMeta(group: data['isGroup'] ?? false),
      reference: data['cid'],
      raw: includeRaw ? MessageRawData.fromJson(data) : null,
    );

    return messageEvent;
  }

  static NotificationEvent mapToNotificationEvent(
      {required dynamic data,
      required String notificationEventType,
      required String origin,
      includeRaw = false}) {
    final notificationType = NOTIFICATION_TYPE_MAP.keys.firstWhere(
      (key) => NOTIFICATION_TYPE_MAP[key] == data['payload']['data']['type'],
      orElse: () => 'BROADCAST',
    );

    List<String> recipients;

    if (data['payload']['recipients'] is List) {
      recipients = List<String>.from(data['payload']['recipients']);
    } else if (data['payload']['recipients'] is String) {
      recipients = [data['payload']['recipients']];
    } else {
      recipients = data['payload']['recipients'].keys.toList();
    }

    final notificationEvent = NotificationEvent(
      event: notificationEventType,
      origin: origin,
      timestamp: data['epoch'].toString(),
      from: data['sender'],
      to: recipients,
      notifID: data['payload_id'].toString(),
      channel: NotificationChannel(
        name: data['payload']['data']['app'],
        icon: data['payload']['data']['icon'],
        url: data['payload']['data']['url'],
      ),
      meta: NotificationMeta(
        type: 'NOTIFICATION.$notificationType',
      ),
      message: NotificationMessage(
        notification: NotificationContent(
          title: data['payload']['notification']['title'],
          body: data['payload']['notification']['body'],
        ),
        payload: NotificationPayload(
          title: data['payload']['data']['asub'],
          body: data['payload']['data']['amsg'],
          cta: data['payload']['data']['acta'],
          embed: data['payload']['data']['aimg'],
          meta: NotificationPayloadMeta(
            domain: data['payload']['data']['additionalMeta']['domain'] ??
                'push.org',
            type: data['payload']['data']['additionalMeta']['type'],
            data: data['payload']['data']['additionalMeta']['data'],
          ),
        ),
      ),
      config: NotificationConfig(
        expiry: data['payload']['data']['etime'],
        silent: data['payload']['data']['silent'] == '1',
        hidden: data['payload']['data']['hidden'] == '1',
      ),
      source: data['source'],
      raw: includeRaw
          ? NotificationRawData(
              verificationProof: data['payload']['verificationProof'],
            )
          : null,
    );

    return notificationEvent;
  }
}
