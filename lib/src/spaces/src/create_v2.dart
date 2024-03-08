import '../../../push_restapi_dart.dart';

Future<SpaceInfoDTO?> createSpaceV2({
  String? account,
  Signer? signer,
  String? pgpPrivateKey,
  required String spaceName,
  required String spaceDescription,
  String? spaceImage,
  required List<String> listeners,
  required List<String> speakers,
  bool isPublic = true,
  required DateTime scheduleAt,
  DateTime? scheduleEnd,
  dynamic rules,
}) async {
  try {
    final spaceRules = rules != null ? convertSpaceRulesToRules(rules) : null;
    final result = await createGroupV2(
      options: ChatCreateGroupTypeV2(
        signer: signer,
        account: account,
        groupName: spaceName,
        groupDescription: spaceDescription,
        members: listeners,
        admins: speakers,
        groupImage: spaceImage,
        isPublic: isPublic,
        groupType: 'spaces',
        pgpPrivateKey: pgpPrivateKey,
        rules: spaceRules,
        config: GroupConfig(
          meta: null,
          scheduleAt: scheduleAt,
          scheduleEnd: scheduleEnd,
          status: 'PENDING',
        ),
      ),
    );

    return result.toSpaceInfo;
  } catch (e) {
    log("[Push SDK] - API  - Error - API createSpace -: $e ");
    rethrow;
  }
}

dynamic convertSpaceRulesToRules(dynamic spaceRules) {
  return {
    "entry": spaceRules['entry'],
    "chat": null,
  };
}
