import '../../../push_restapi_dart.dart';

Future<void> joinSpace() async {
  try {
    var data = providerContainer.read(PushSpaceProvider).data;
    
    final space =
        await getSpaceById(spaceId: data.spaceId);

    if (space.status != ChatStatus.ACTIVE) {
      throw Exception('Space not active yet');
    }

    // checking what is the current role of caller address

    var isSpeaker = false;
    var isListener = false;
    // TODO: get local address from Wallet provider
    final localAddress = pCAIP10ToWallet();
    space.members.forEach((member) {
      if (pCAIP10ToWallet(member.wallet) == localAddress) {
        if (member.isSpeaker) {
          isSpeaker = true;
        } else {
          isListener = true;
        }
      }
    });

    var isSpeakerPending = false;
    space.pendingMembers.forEach((pendingMember) {
      if (pCAIP10ToWallet(pendingMember.wallet) == localAddress &&
          pendingMember.isSpeaker) {
        isSpeakerPending = true;
      }
    });

    // TODO: check from livekit SDK if we are already part of the room
    // if yes -> return

    // according to the found role (speaker or listener), executing req logic

    // if speaker is pending then approve first or if listener is pending/not found then approve first
    if (!isSpeaker && !isListener) {
      print('CALLING APPROVE');
      // TODO: Get the signer, pgpPrivateKey here
      await approveSpaceRequest(
          senderAddress: data.spaceId,
          signer: ,
          pgpPrivateKey: );
    }

    if (isSpeaker || isSpeakerPending) {
      // TODO: Add the join room logic here
    }

    final updatedSpace =
        await getSpaceById(spaceId: data.spaceId);

    // update space data
    providerContainer.read(PushSpaceProvider.notifier).setData((oldData){
      return SpaceData.fromSpaceDTO(updatedSpace, data.liveSpaceData);
    });
  } catch (err) {
    print('[Push SDK] - API  - Error - API join -: $err');
    throw Exception('[Push SDK] - API  - Error - API join -: $err');
  }
}
