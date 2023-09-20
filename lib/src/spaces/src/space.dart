// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livekit_client/livekit_client.dart';

import 'helpers/live_peer.dart';
import 'initialize.dart';
import 'join.dart';
import 'update_space_meta.dart';

import '../../../push_restapi_dart.dart';

final PushSpaceProvider = ChangeNotifierProvider<SpaceStateNotifier>((ref) {
  return SpaceStateNotifier();
});

typedef SetDataFunction = SpaceData Function(SpaceData);

LiveSpaceData initLiveSpaceData = LiveSpaceData(
  host: AdminPeer(),
  // coHosts: [],
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
  String? _playbackUrl;
  String? get spacePlaybackUrl => _playbackUrl;

  _setPlaybackUrl(String? url) {
    _playbackUrl = url;
    notifyListeners();
    log('_setPlaybackUrl _playbackUrl: $_playbackUrl');
  }

  // to store data related to push space
  late SpaceData data;

  void setData(SetDataFunction fn) {
    final newState = fn(data);
    data = newState;
    log('setData: $data');
    notifyListeners();
  }

  SpaceStateNotifier() {
    data = initSpaceData;
  }

  // TODO: add -> onReceiveMetaMessage, stop

  initialize({
    required String spaceId,
  }) {
    initializeSpace(spaceId: spaceId);
  }

  updateMeta({
    required String meta,
  }) {
    updateSpaceMeta(meta: meta);
  }

  Future<SpaceDTO?> join({
    required String spaceId,
    String? address,
    String? pgpPrivateKey,
    Signer? signer,
    String? livepeerApiKey,
  }) async {
    initialize(spaceId: spaceId);
    if (livepeerApiKey != null) {
      setLivePeerKey(livepeerApiKey);
    }
    return joinSpace(
      spaceId: spaceId,
      address: address,
      pgpPrivateKey: pgpPrivateKey,
      signer: signer,
      updatePlaybackUrl: _setPlaybackUrl,
      updateRoom: _updateLocalUserRoom,
    );
  }

  Future<SpaceDTO?> start({
    String? accountAddress,
    Signer? signer,
    required String spaceId,
    String? livepeerApiKey,
    required dynamic Function(ProgressHookType) progressHook,
  }) async {
    initialize(spaceId: spaceId);
    if (livepeerApiKey != null) {
      setLivePeerKey(livepeerApiKey);
    }
    return startSpace(
      accountAddress: accountAddress,
      signer: signer,
      spaceId: spaceId,
      progressHook: progressHook,
      updateRoom: _updateLocalUserRoom,
    );
  }

  _updateLocalUserRoom(Room? localRoom) {
    _room = localRoom;
    notifyListeners();
  }

  bool get isSpeakerConnected => _room != null;
  bool get isListenerConnected => _playbackUrl != null;

  bool get isMicOn => _isMicOn;
  bool _isMicOn = false;
  setMicrophoneState(bool isOn) async {
    if (_room != null) {
      _isMicOn = isOn;
      await _room?.localParticipant?.setMicrophoneEnabled(isOn);

      // update the mic status of the client to others
      final localAddress = getCachedWallet()!.address!;
      final spaceData = providerContainer.read(PushSpaceProvider).data;
      for (var index = 0;
          index < spaceData.liveSpaceData.speakers.length;
          index++) {
        if (spaceData.liveSpaceData.speakers[index].address == localAddress) {
          spaceData.liveSpaceData.speakers[index].audio = isOn;
        }
      }

      sendLiveSpaceData(
          updatedLiveSpaceData: spaceData.liveSpaceData,
          action: META_ACTION
              .USER_INTERACTION, // TODO: Need a better action for mic toggle
          affectedAddresses: [localAddress],
          spaceId: spaceData.spaceId);

      log('updatedLiveSpaceData ${spaceData.liveSpaceData}');
      providerContainer.read(PushSpaceProvider.notifier).setData((oldData) {
        return spaceData;
      });

      notifyListeners();
    }
  }

  toggleMic() {
    setMicrophoneState(!_isMicOn);
  }

  Future leave() async {
    try {
      _playbackUrl = null;
      if (_room != null) {
        await setMicrophoneState(false);
        _room!.disconnect();

        // fire a meta message signaling that you have left the group
        final localAddress = getCachedWallet()!.address!;
        final spaceData = providerContainer.read(PushSpaceProvider).data;
        spaceData.liveSpaceData.speakers.removeWhere((speaker) => speaker.address == localAddress);

        sendLiveSpaceData(
            updatedLiveSpaceData: spaceData.liveSpaceData,
            action: META_ACTION.DEMOTE_FROM_SPEAKER, // TODO: Need a better action for speaker leaving
            affectedAddresses: [localAddress],
            spaceId: spaceData.spaceId);

        log('updatedLiveSpaceData ${spaceData.liveSpaceData}');
        providerContainer.read(PushSpaceProvider.notifier).setData((oldData) {
          return spaceData;
        });
      }

      _room = null;
    } catch (e) {
      log('leave error $e');
    }

    notifyListeners();
  }

  stop() {}
}
