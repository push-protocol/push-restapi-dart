import 'dart:convert';

import 'package:livekit_client/livekit_client.dart';

import 'helpers/live_peer.dart';
import '../../../push_restapi_dart.dart';

Future<SpaceDTO?> joinSpace({
  required String spaceId,
  String? address,
  String? pgpPrivateKey,
  Signer? signer,
  required Function(Room?) updateRoom,
  required Function(String?) updatePlaybackUrl,
}) async {
  try {
    final SpaceDTO space = await getSpaceById(spaceId: spaceId);

    if (space.status != ChatStatus.ACTIVE) {
      throw Exception('Space not active yet');
    }

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

    // if speaker is pending then approve first or if listener is pending/not found then approve first
    if (!isSpeaker && !isListener) {
      final localWallet = getCachedWallet();
      await approveSpaceRequest(
          senderAddress: spaceId,
          signer: signer ?? localWallet?.signer,
          pgpPrivateKey: pgpPrivateKey ?? localWallet?.pgpPrivateKey);
    }

    if (isSpeaker || isSpeakerPending) {
      if (space.meta == null) {
        throw Exception('Space meta not updated');
      }
      final meta = jsonDecode(space.meta ?? '');

      final roomId = meta["roomId"];

      final room = await addSpeakingParticipant(
          roomId: roomId, participantName: localAddress);
      updateRoom(room);
    } else {
      if (space.meta == null) {
        throw Exception('Space meta not updated');
      }
      final meta = jsonDecode(space.meta ?? '');

      final playbackId = meta["playbackId"];
      final String? playbackUrl = await getPlaybackUrl(playbackId: playbackId);

      updatePlaybackUrl(playbackUrl);
    }

    return space;
  } catch (err) {
    log('[Push SDK] - API  - Error - API join -: $err');
    throw Exception('[Push SDK] - API  - Error - API join -: $err');
  }
}
