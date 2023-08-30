import '../../../push_restapi_dart.dart'; // Replace with actual import

Future<void> updateSpaceMeta({
  required String meta,
  required Signer signer,
  required String pgpPrivateKey,
}) async {
  try {
    var data = providerContainer.read(PushSpaceProvider).data;

    final space = await getSpaceById(spaceId: data.spaceId);

    final convertedMembers = getSpacesMembersList(
      space.members,
      space.pendingMembers,
    );
    final convertedAdmins = getSpaceAdminsList(
      space.members,
      space.pendingMembers,
    );

    final group = await updateGroup(
      chatId: data.spaceId,
      groupName: space.spaceName,
      groupImage: space.spaceImage!,
      groupDescription: space.spaceDescription!,
      isPublic: space.isPublic,
      members: convertedMembers,
      admins: convertedAdmins,
      signer: signer,
      pgpPrivateKey: pgpPrivateKey,
      meta: meta,
    );

    providerContainer.read(PushSpaceProvider.notifier).setData((oldData) {
      return SpaceData.fromSpaceDTO(
          groupDtoToSpaceDto(group!), data.liveSpaceData);
    });
  } catch (err) {
    print('[Push SDK] - API  - Error - API update - : $err');
    rethrow;
  }
}
