import 'dart:convert';

import 'package:livekit_client/livekit_client.dart';
import 'helpers/live_peer.dart';
import '../../../push_restapi_dart.dart';

Future<SpaceDTO?> startSpace({
  String? accountAddress,
  Signer? signer,
  required String spaceId,
  required Function(ProgressHookType) progressHook,
  required Function(Room?) updateRoom,
}) async {
  try {
    accountAddress ??= getCachedWallet()?.address;
    signer ??= getCachedWallet()?.signer;

    final space = await getSpaceById(spaceId: spaceId);

    if (space.status != ChatStatus.PENDING) {
      throw Exception(
          'Unable to start the space as it is not in the pending state');
    }

    final convertedMembers =
        getSpacesMembersList(space.members, space.pendingMembers);
    final convertedAdmins =
        getSpaceAdminsList(space.members, space.pendingMembers);

    ////Create Stream
    final stream = await createStreamService(spaceName: space.spaceName);

    ///Create room
    final roomId = await createLivePeerRoom();

    ///add local user as participant
    final room = await addSpeakingParticipant(
      roomId: roomId,
      participantName: accountAddress ?? signer!.getAddress(),
    );
    updateRoom(room);

    ///connect room to stream
    await startLiveStream(roomId: roomId, streamId: stream.streamId!);

    final group = await updateGroup(
      chatId: spaceId,
      groupName: space.spaceName,
      groupImage: space.spaceImage!,
      groupDescription: space.spaceDescription!,
      members: convertedMembers,
      admins: convertedAdmins,
      signer: signer,
      meta: jsonEncode({
        "playbackId": stream.playbackId,
        "roomId": roomId,
      }),
      scheduleAt: space.scheduleAt,
      scheduleEnd: space.scheduleEnd,
      status: ChatStatus.ACTIVE,
      isPublic: space.isPublic,
    );

    if (group != null) {
      return groupDtoToSpaceDto(group);
    } else {
      throw Exception('Error while updating Space : $spaceId');
    }
  } catch (e) {
    print('[Push SDK] - API  - Error - API update -:  $e');
    rethrow;
  }
}
