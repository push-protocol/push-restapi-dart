class GroupAccess {
  bool entry;
  bool chat;
  dynamic rules;

  GroupAccess({
    required this.entry,
    required this.chat,
    this.rules,
  });

  factory GroupAccess.fromJson(Map<String, dynamic> json) {
    return GroupAccess(
        entry: json['entry'] ?? false,
        chat: json['chat'] ?? false,
        rules: json['rules']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'entry': entry,
      'chat': chat,
      'rules': rules,
    };
    return data;
  }
}

class SpaceAccess {
  bool entry;
  bool chat;

  SpaceAccess({
    required this.entry,
    required this.chat,
  });

  factory SpaceAccess.fromJson(Map<String, dynamic> json) {
    return SpaceAccess(
      entry: json['entry'] ?? false,
      chat: json['chat'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'entry': entry,
      'chat': chat,
    };
    return data;
  }
}
