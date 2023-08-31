// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:push_restapi_dart/src/spaces/src/initialize.dart';
import 'package:push_restapi_dart/src/spaces/src/join.dart';
import 'package:push_restapi_dart/src/spaces/src/update_space_meta.dart';

import '../../../push_restapi_dart.dart';

final PushSpaceProvider = ChangeNotifierProvider<SpaceStateNotifier>((ref) {
  return SpaceStateNotifier();
});

typedef SetDataFunction = SpaceData Function(SpaceData);

LiveSpaceData initLiveSpaceData = LiveSpaceData(
  host: AdminPeer(),
  coHosts: [],
  speakers: [],
  listeners: [],
);

SpaceData initSpaceData = SpaceData(
  members: [],
  pendingMembers: [],
  numberOfERC20: -1,
  numberOfNFTTokens: -1,
  verificationProof: '',
  spaceName: '',
  isPublic: false,
  spaceDescription: '',
  spaceCreator: '',
  spaceId: '',
  liveSpaceData: initLiveSpaceData,
);

class SpaceStateNotifier extends ChangeNotifier {
  // to store the room data upon start/join
  Room? _room;

  // TODO: store signer, localAddress on class so that dev doesnt have to pass it everywhere

  // to store data related to push space
  late SpaceData data;

  void setData(SetDataFunction fn) {
    final newState = fn(data);
    data = newState;
    log('setData: $data');
  }

  SpaceStateNotifier() {
    data = initSpaceData;
  }
  // SpaceStateNotifier() : super(initSpaceData);

  // TODO: add -> start, onReceiveMetaMessage, leave, stop

  initialize({
    required String spaceId,
  }) {
    initializeSpace(spaceId: spaceId);
  }

  updateMeta({
    required String meta,
  }) {
    final localWallet = getCachedWallet();

    updateSpaceMeta(
      meta: meta,
      signer: localWallet!.signer!,
      pgpPrivateKey: localWallet.pgpPrivateKey!,
    );
  }

  join({
    required String spaceId,
    String? address,
    String? pgpPrivateKey,
    Signer? signer,
  }) {
    joinSpace(
      spaceId: spaceId,
      address: address,
      pgpPrivateKey: pgpPrivateKey,
      signer: signer,
    );
  }

  start({
    String? accountAddress,
    Signer? signer,
    required String spaceId,
    String? livepeerApiKey,
    required dynamic Function(ProgressHookType) progressHook,
  }) {
    livepeerApiKey ??= '4217cd75-ce67-49af-a6dd-aa1581f7d651';
    startSpace(
      accountAddress: accountAddress,
      signer: signer,
      spaceId: spaceId,
      livepeerApiKey: livepeerApiKey,
      progressHook: progressHook,
    );
  }

  updateLocalUserRoom(Room? localRoom) {
    _room = localRoom;
    notifyListeners();
  }

  setMicrophoneState(bool isOn) {
    if (_room != null) {
      _room?.localParticipant?.setMicrophoneEnabled(isOn);
    }
  }

  leave() {}

  stop() {}
}
