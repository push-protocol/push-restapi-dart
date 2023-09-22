// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livekit_client/livekit_client.dart';

import 'helpers/live_peer.dart';
import 'on_receive_meta_message_for_space.dart';
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
  SpaceStateNotifier() {
    data = initSpaceData;
  }
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
  LiveSpaceData get liveSpaceData => data.liveSpaceData;

  void setData(SetDataFunction fn) {
    final newState = fn(data);
    data = newState;
    log('setData: $data');
    notifyListeners();
  }

  onReceiveMetaMessage(Map<String, dynamic> metaMessage) async {
    final result =
        await onReceiveMetaMessageForSpace(metaMessage, data.spaceId);
    if (result != null) {
      data = result;
      notifyListeners();
    }
  }

  Future<SpaceData?> initializeData({
    required String spaceId,
  }) async {
    final result = await initializeSpace(spaceId: spaceId);
    if (result != null) {
      data = result;
      notifyListeners();
      return result;
    } else {
      throw Exception('Invalid Space id');
    }
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
    if (spaceId != data.spaceId) {
      await initializeData(spaceId: spaceId);
    }

    if (livepeerApiKey != null) {
      setLivePeerKey(livepeerApiKey);
    }

    final result = await joinSpace(
      spaceId: spaceId,
      address: address,
      pgpPrivateKey: pgpPrivateKey,
      signer: signer,
      updatePlaybackUrl: _setPlaybackUrl,
      updateRoom: _updateLocalUserRoom,
      spaceData: data,
    );

    if (result != null) {
      data = result;
      notifyListeners();
    }

    return result;
  }

  Future<SpaceDTO?> start({
    String? accountAddress,
    Signer? signer,
    required String spaceId,
    String? livepeerApiKey,
    required dynamic Function(ProgressHookType) progressHook,
  }) async {
    if (livepeerApiKey != null) {
      setLivePeerKey(livepeerApiKey);
    }

    final result = await startSpace(
      accountAddress: accountAddress,
      signer: signer,
      spaceId: spaceId,
      progressHook: progressHook,
      updateRoom: _updateLocalUserRoom,
    );

    log('start: result= $result');
    if (result != null) {
      data = result;
      notifyListeners();
      log('start: result=liveSpaceData ${result.liveSpaceData.toJson()}');
    }

    return result;
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

      final spaceData = data;
      final speakers = data.liveSpaceData.speakers.toList();

      if (spaceData.liveSpaceData.host.address == localAddress) {
        spaceData.liveSpaceData.host.audio = isOn;
      }

      for (var speaker in speakers) {
        if (speaker.address == localAddress) {
          speaker.audio = isOn;
          break;
        }
      }

      spaceData.liveSpaceData.speakers = speakers;

      sendLiveSpaceData(
        updatedLiveSpaceData: spaceData.liveSpaceData,
        action: META_ACTION
            .USER_INTERACTION, // TODO: Need a better action for mic toggle
        affectedAddresses: [localAddress],
        spaceId: spaceData.spaceId,
      );

      data = spaceData;
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
        final spaceData = data;

        final speakers = <AdminPeer>[];

        for (var speaker in spaceData.liveSpaceData.speakers) {
          if (speaker.address != localAddress) {
            speakers.add(speaker);
          }
        }
        spaceData.liveSpaceData.speakers = speakers;

        sendLiveSpaceData(
            updatedLiveSpaceData: spaceData.liveSpaceData,
            action: META_ACTION
                .DEMOTE_FROM_SPEAKER, // TODO: Need a better action for speaker leaving
            affectedAddresses: [localAddress],
            spaceId: spaceData.spaceId);

        data = initSpaceData;
      }

      _room = null;
    } catch (e) {
      log('leave error $e');
    }

    notifyListeners();
  }

  stop() {}
}
