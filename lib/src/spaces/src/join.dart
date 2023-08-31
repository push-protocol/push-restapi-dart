import 'dart:convert';

import 'package:livekit_client/livekit_client.dart';

import '../../../push_restapi_dart.dart';

Future<SpaceDTO?> joinSpace({
  required String spaceId,
  String? address,
  String? pgpPrivateKey,
  Signer? signer,
  required Function(Room?) updateRoom,
}) async {
  try {
    final SpaceDTO space = await getSpaceById(spaceId: spaceId);

    if (space.status != ChatStatus.ACTIVE) {
      throw Exception('Space not active yet');
    }

    // SpaceData spaceData = providerContainer.read(PushSpaceProvider).data;

    // checking what is the current role of caller address

    var isSpeaker = false;
    var isListener = false;
    final localAddress = address ?? getCachedWallet()?.address;
    if (localAddress == null) {
      throw Exception('Cannot find local user address');
    }

    for (var member in space.members) {
      if (pCAIP10ToWallet(member.wallet) == localAddress) {
        if (member.isSpeaker) {
          isSpeaker = true;
        } else {
          isListener = true;
        }
      }
    }

    var isSpeakerPending = false;
    for (var pendingMember in space.pendingMembers) {
      if (pCAIP10ToWallet(pendingMember.wallet) == localAddress &&
          pendingMember.isSpeaker) {
        isSpeakerPending = true;
      }
    }

    // TODO: check from livekit SDK if we are already part of the room
    // if yes -> return

    // according to the found role (speaker or listener), executing req logic

    // if speaker is pending then approve first or if listener is pending/not found then approve first
    if (!isSpeaker && !isListener) {
      print('CALLING APPROVE');
      // TODO: Get the signer, pgpPrivateKey here
      final localWallet = getCachedWallet();
      await approveSpaceRequest(
          senderAddress: spaceId,
          signer: signer ?? localWallet?.signer,
          pgpPrivateKey: pgpPrivateKey ?? localWallet?.pgpPrivateKey);
    }

    if (isSpeaker || isSpeakerPending) {
      // TODO: Add the join room logic here
      final roomId = jsonDecode(space.meta ?? '')["roomId"];

      final room = await addSpeakingParticipant(
          roomId: roomId, participantName: localAddress);
      updateRoom(room);
    }

    return await getSpaceById(spaceId: spaceId);

    // update space data
    // providerContainer.read(PushSpaceProvider.notifier).setData((oldData) {
    //   return SpaceData.fromSpaceDTO(updatedSpace, spaceData.liveSpaceData);
    // });
  } catch (err) {
    print('[Push SDK] - API  - Error - API join -: $err');
    throw Exception('[Push SDK] - API  - Error - API join -: $err');
  }
}
