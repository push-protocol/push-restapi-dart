// ignore_for_file: constant_identifier_names

import '../../../../push_restapi_dart.dart';

class SpaceSchedule {
  final DateTime start;
  final DateTime? end;

  SpaceSchedule({
    required this.start,
    this.end,
  });
}

class SpaceUpdateOptions {
  String? name;
  String? description;
  String? image;
  DateTime? scheduleAt;
  DateTime? scheduleEnd;
  ChatStatus? status;
  String? meta;
  dynamic rules;

  SpaceUpdateOptions({
    this.name,
    this.description,
    this.image,
    this.scheduleAt,
    this.scheduleEnd,
    this.status,
    this.meta,
    this.rules,
  });
}

class SpaceCreationOptions {
  final String description;
  final String image;
  late final SpaceParticipants participants;
  final SpaceSchedule schedule;
  final dynamic rules;
  final bool private;

  SpaceCreationOptions({
    required this.description,
    required this.image,
    SpaceParticipants? participants,
    required this.schedule,
    this.rules,
    required this.private,
  }) {
    this.participants = participants ?? SpaceParticipants();
  }
}

class SpaceParticipants {
  final List<String> speakers;
  final List<String> listeners;

  SpaceParticipants({
    this.speakers = const [],
    this.listeners = const [],
  });
}

enum SpaceRoles { LISTENER, SPEAKERS }

extension SpaceRolesExtension on SpaceRoles {
  String get toGroupValue {
    switch (this) {
      case SpaceRoles.SPEAKERS:
        return 'ADMIN';
      case SpaceRoles.LISTENER:
        return 'MEMBER';

      default:
        return 'MEMBER';
    }
  }
}

enum SpaceListType { SPACES, REQUESTS }

extension SpaceListTypeExtension on SpaceListType {
  ChatListType get toChatListType {
    switch (this) {
      case SpaceListType.SPACES:
        return ChatListType.CHATS;
      case SpaceListType.REQUESTS:
        return ChatListType.REQUESTS;
      default:
        throw Exception('Unsupported SpaceListType: $this');
    }
  }
}
