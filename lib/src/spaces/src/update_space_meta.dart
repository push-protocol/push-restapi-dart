import '../../../push_restapi_dart.dart'; // Replace with actual import

Future<SpaceDTO> updateSpaceMeta({
  required String meta,
  required String spaceId,
  Signer? signer,
  String? pgpPrivateKey,
}) async {
  signer ??= getCachedWallet()?.signer;
  pgpPrivateKey ??= getCachedWallet()?.pgpPrivateKey;

  try {
    final space = await getSpaceById(spaceId: spaceId);

    final convertedMembers = getSpacesMembersList(
      space.members,
      space.pendingMembers,
    );
    final convertedAdmins = getSpaceAdminsList(
      space.members,
      space.pendingMembers,
    );

    final group = await updateGroup(
      chatId: spaceId,
      groupName: space.spaceName,
      groupImage: space.spaceImage,
      groupDescription: space.spaceDescription!,
      isPublic: space.isPublic,
      members: convertedMembers,
      admins: convertedAdmins,
      signer: signer,
      pgpPrivateKey: pgpPrivateKey,
      meta: meta,
    );

    // return SpaceData.fromSpaceDTO(
    //     groupDtoToSpaceDto(group!), data.liveSpaceData);
    return groupDtoToSpaceDto(group!);
  } catch (err) {
    print('[Push SDK] - API  - Error - API update - : $err');
    rethrow;
  }
}
