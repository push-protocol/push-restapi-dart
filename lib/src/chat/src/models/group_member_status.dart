class GroupMemberStatus {
  bool isMember;
  bool isPending;
  bool isAdmin;

  GroupMemberStatus({
    required this.isMember,
    required this.isPending,
    required this.isAdmin,
  });

  factory GroupMemberStatus.fromJson(Map<String, dynamic> json) {
    return GroupMemberStatus(
      isMember: json['isMember'],
      isPending: json['isPending'],
      isAdmin: json['isAdmin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isMember': isMember,
      'isPending': isPending,
      'isAdmin': isAdmin,
    };
  }
}
