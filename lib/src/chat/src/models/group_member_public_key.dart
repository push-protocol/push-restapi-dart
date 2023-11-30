class GroupMemberPublicKey {
  String did;
  String publicKey;

  GroupMemberPublicKey({
    required this.did,
    required this.publicKey,
  });

  factory GroupMemberPublicKey.fromJson(Map<String, dynamic> json) {
    return GroupMemberPublicKey(
      did: json['did'],
      publicKey: json['publicKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'did': did,
      'publicKey': publicKey,
    };
  }
}
