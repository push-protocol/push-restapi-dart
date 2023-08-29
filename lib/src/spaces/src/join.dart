import '../../../push_restapi_dart.dart';

Future<void> join() async {
  try {
    final space =
        await getSpaceById(spaceId: this.spaceSpecificData['spaceId']);

    if (space.status != ChatStatus.ACTIVE) {
      throw Exception('Space not active yet');
    }

    // checking what is the current role of caller address

    var isSpeaker = false;
    var isListener = false;
    final localAddress = pCAIP10ToWallet(this.data['local']['address']);
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

    final hostAddress = pCAIP10ToWallet(space.spaceCreator);
    final incomingIndex =
        getIncomingIndexFromAddress(this.data['incoming'], hostAddress);

    // check if we aren't already connected to the host
    if ((isSpeaker || isSpeakerPending) && incomingIndex > -1) {
      return;
    }

    // according to the found role (speaker or listener), executing req logic

    // if speaker is pending then approve first or if listener is pending/not found then approve first
    if (!isSpeaker && !isListener) {
      print('CALLING APPROVE');
      await approveSpaceRequest(
          senderAddress: this.spaceSpecificData['spaceId'],
          signer: this.signer,
          pgpPrivateKey: this.pgpPrivateKey);
    }

    if (isSpeaker || isSpeakerPending) {
      // TODO: Add the join room logic here
    }

    final updatedSpace =
        await getSpaceById(spaceId: this.spaceSpecificData['spaceId']);

    print('UPDATED SPACE $updatedSpace');
    // update space specific data
    // this.setSpaceSpecificData(() => {
    //       ...updatedSpace,
    //       liveSpaceData: this.spaceSpecificData['liveSpaceData'],
    //     });
  } catch (err) {
    print('[Push SDK] - API  - Error - API join -: $err');
    throw Exception('[Push SDK] - API  - Error - API join -: $err');
  }
}
