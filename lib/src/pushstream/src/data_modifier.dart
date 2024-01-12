import '../../../push_restapi_dart.dart';

class DataModifier {
  static Future<dynamic> handleChatGroupEvent({
    required dynamic data,
    bool includeRaw = false,
  }) async {
    switch (data['eventType']) {
      case 'create':
        return mapToCreateGroupEvent(data, includeRaw);
      case 'update':
        return mapToUpdateGroupEvent(data, includeRaw);
      case GroupEventType.joinGroup:
        return mapToJoinGroupEvent(data, includeRaw);
      case GroupEventType.leaveGroup:
        return mapToLeaveGroupEvent(data, includeRaw);
      case MessageEventType.request:
        return mapToRequestEvent(data, includeRaw);
      case GroupEventType.remove:
        return mapToRemoveEvent(data, includeRaw);
      default:
        log('Unknown eventType: ${data['eventType']}');
        return data;
    }
  }

  static dynamic mapToCreateGroupEvent(dynamic incomingData, bool includeRaw) {
    return mapToGroupEvent(
        GroupEventType.createGroup, incomingData, includeRaw);
  }

  static dynamic mapToGroupEvent(eventType, incomingData, bool includeRaw) {
    final metaAndRaw = buildChatGroupEventMetaAndRaw(incomingData, includeRaw);
    final groupEvent = {
      'event': eventType,
      'origin': incomingData['messageOrigin'],
      'timestamp': incomingData['timestamp'],
      'chatId': incomingData['chatId'],
      'from': incomingData['from'],
      'meta': metaAndRaw['meta'],
    };

    if (includeRaw) {
      groupEvent['raw'] = metaAndRaw['raw'];
    }

    return groupEvent;
  }

  static dynamic buildChatGroupEventMetaAndRaw(incomingData, bool includeRaw) {
    final meta = {
      'name': incomingData['groupName'],
      'description': incomingData['groupDescription'],
      'image': incomingData['groupImage'],
      'owner': incomingData['groupCreator'],
      'private': !incomingData['isPublic'],
      'rules': incomingData['rules'],
    };

    if (includeRaw) {
      final raw = {'verificationProof': incomingData['verificationProof']};
      return {'meta': meta, 'raw': raw};
    }
    return {'meta': meta};
  }

  static String convertToProposedName(String currentEventName) {
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
    switch (data['event']) {
      case ProposedEventNames.LeaveGroup:
      case ProposedEventNames.JoinGroup:
        data['to'] = null;
        break;

      case ProposedEventNames.Accept:
      case ProposedEventNames.Reject:
        if (data['meta']?['group'] != null) {
          data['to'] = null;
        }
        break;

      default:
        break;
    }
  }

  static handleChatEvent(dynamic data, [includeRaw = false]) {
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

    var key = data['eventType'] ?? data['messageCategory'];

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

  static dynamic mapToMessageEvent(
    Map<String, dynamic> data,
    bool includeRaw,
    String eventType,
  ) {
    final messageEvent = {
      'event': eventType,
      'origin': data[['messageOrigin']],
      'timestamp': data['timestamp'].toString(),
      'chatId': data['chatId'], // TODO: ChatId not working for w2w
      'from': data['fromCAIP10'],
      'to': [
        if (data['toCAIP10'] != null) data['toCAIP10']
      ], // TODO: Assuming 'to' is an array in MessageEvent. Update as necessary.
      'message': {
        'type': data['messageType'],
        'content': data['messageContent'],
      },
      'meta': {
        'group': data['isGroup'] ?? false,
      },
      'reference': data['cid'],
    };

    if (includeRaw) {
      final rawData = {
        'fromCAIP10': data['fromCAIP10'],
        'toCAIP10': data['toCAIP10'],
        'fromDID': data['fromDID'],
        'toDID': data['toDID'],
        'encType': data['encType'],
        'encryptedSecret': data['encryptedSecret'],
        'signature': data['signature'],
        'sigType': data['sigType'],
        'verificationProof': data['verificationProof'],
        'previousReference': data['link'],
      };
      messageEvent['raw'] = rawData;
    }

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

  static dynamic mapToUpdateGroupEvent(incomingData, bool includeRaw) {
    return mapToGroupEvent(
      GroupEventType.updateGroup,
      incomingData,
      includeRaw,
    );
  }

  static mapToJoinGroupEvent(data, bool includeRaw) {
    final baseEventData = {
      'origin': data['messageOrigin'],
      'timestamp': data['timestamp'],
      'chatId': data['chatId'],
      'from': data['from'],
      'to': data['to'],
      'event': GroupEventType.joinGroup,
    };

    return includeRaw
        ? {
            ...baseEventData,
            'raw': {'verificationProof': data['verificationProof']},
          }
        : baseEventData;
  }

  static dynamic mapToLeaveGroupEvent(data, bool includeRaw) {
    final baseEventData = {
      'origin': data['messageOrigin'],
      'timestamp': data['timestamp'],
      'chatId': data['chatId'],
      'from': data['from'],
      'to': data['to'],
      'event': GroupEventType.leaveGroup,
    };

    return includeRaw
        ? {
            ...baseEventData,
            'raw': {'verificationProof': data['verificationProof']},
          }
        : baseEventData;
  }

  static dynamic mapToRequestEvent(data, bool includeRaw) {
    final eventData = {
      'origin': data['messageOrigin'],
      'timestamp': data['timestamp'],
      'chatId': data['chatId'],
      'from': data['from'],
      'to': data['to'],
      'event': MessageEventType.request,
      'meta': {
        'group': data['isGroup'] ?? false,
      },
    };

    if (includeRaw) {
      eventData['raw'] = {'verificationProof': data['verificationProof']};
    }
    return eventData;
  }

  static dynamic mapToRemoveEvent(data, bool includeRaw) {
    final eventData = {
      'origin': data['messageOrigin'],
      'timestamp': data['timestamp'],
      'chatId': data['chatId'],
      'from': data['from'],
      'to': data['to'],
      'event': GroupEventType.remove,
    };

    if (includeRaw) {
      eventData['raw'] = {'verificationProof': data['verificationProof']};
    }
    return eventData;
  }
}
