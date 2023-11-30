class ChatMemberCounts {
  int overallCount;
  int adminsCount;
  int membersCount;
  int pendingCount;
  int approvedCount;

  ChatMemberCounts({
    required this.overallCount,
    required this.adminsCount,
    required this.membersCount,
    required this.pendingCount,
    required this.approvedCount,
  });

  factory ChatMemberCounts.fromJson(Map<String, dynamic> json) {
    return ChatMemberCounts(
      overallCount: json['overallCount'],
      adminsCount: json['adminsCount'],
      membersCount: json['membersCount'],
      pendingCount: json['pendingCount'],
      approvedCount: json['approvedCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overallCount': overallCount,
      'adminsCount': adminsCount,
      'membersCount': membersCount,
      'pendingCount': pendingCount,
      'approvedCount': approvedCount,
    };
  }
}
