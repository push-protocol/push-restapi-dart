// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  late dynamic _room;

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

  join() {
    joinSpace();
  }

  start() {}

  leave() {}

  stop() {}
}
