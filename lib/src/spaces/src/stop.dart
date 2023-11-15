import 'dart:convert';

import '../../../push_restapi_dart.dart';
import 'helpers/live_peer.dart';

Future<SpaceData> stop_({
  required SpaceData spaceData,
  required Future<void> Function() disconnectFromRoom,
}) async {
  try {
    final space = await getSpaceById(spaceId: spaceData.spaceId);

    if (space.status == ChatStatus.ENDED) {
      throw Exception('Space already ended');
    }

    // send a meta message signaling end of space to all the joinees
    await sendLiveSpaceData(
        messageType: MessageType.META,
        updatedLiveSpaceData: spaceData.liveSpaceData,
        content: CHAT.META_SPACE_END,
        affectedAddresses: [],
        spaceId: spaceData.spaceId);

    final convertedMembers =
        getSpacesMembersList(space.members, space.pendingMembers);
    final convertedAdmins =
        getSpaceAdminsList(space.members, space.pendingMembers);

    final group = await updateGroup(
        chatId: spaceData.spaceId,
        groupName: space.spaceName,
        groupImage: space.spaceImage,
        groupDescription: space.spaceDescription!,
        members: convertedMembers,
        admins: convertedAdmins,
        scheduleAt: space.scheduleAt,
        scheduleEnd: space.scheduleEnd,
        status: ChatStatus.ENDED,
        isPublic: space.isPublic);

    // end livepeer's livestream
    final streamId = jsonDecode(space.meta ?? '')['streamId'];
    endLiveStream(streamId: streamId);

    // TODO: Close the multiparticipant room

    // disconnect from the room
    await disconnectFromRoom();

    if (group != null) {
      final space = groupDtoToSpaceDto(group);

      // reset admin data from livespacedata
      spaceData.liveSpaceData.host = AdminPeer();
      final result = SpaceData.fromSpaceDTO(space, spaceData.liveSpaceData);

      return result;
    } else {
      throw Exception('Error while stopping the space : $spaceData.spaceId');
    }
  } catch (e) {
    print('[Push SDK] - API  - Error - API stop -:  $e');
    rethrow;
  }
}
