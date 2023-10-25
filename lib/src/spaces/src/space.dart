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
    // when the space isnt joined we dont act on the recieved meta messages
    if (data.spaceId == '') return;

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

  /// To be called by a listener and is requesting to be promoted as a speaker
  Future<void> requestToBePromoted() async {
    final localAddress = getCachedWallet()!.address!;

    // check is the caller is an active listener & modify listener data accordingly
    bool isActiveListener = false;
    for (int i = 0; i < data.liveSpaceData.listeners.length; i++) {
      ListenerPeer listener = data.liveSpaceData.listeners[i];
      if (listener.address == pCAIP10ToWallet(localAddress)) {
        if (listener.handRaised == true) {
          // listener's hand is already raised
          return;
        }

        listener.handRaised = true;
        isActiveListener = true;
      }
    }

    if (!isActiveListener) {
      throw Exception("Local user is not a listener");
    }

    // send a user activity message
    sendLiveSpaceData(
        messageType: MessageType.USER_ACTIVITY,
        updatedLiveSpaceData: data.liveSpaceData,
        content: CHAT.UA_LISTENER_REQUEST_MIC,
        affectedAddresses: [localAddress],
        spaceId: data.spaceId);

    notifyListeners();
  }

  /// Promotion request is accepted by the host
  Future<void> acceptPromotionRequest(
      {required String promoteeAddress}) async {}

  /// Promotion request is rejected by the host
  Future<void> rejectPromotionRequest(
      {required String promoteeAddress}) async {}

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

      String metaMessageContent =
          isOn == true ? CHAT.UA_SPEAKER_MIC_ON : CHAT.UA_SPEAKER_MIC_OFF;

      sendLiveSpaceData(
        messageType: MessageType.USER_ACTIVITY,
        updatedLiveSpaceData: spaceData.liveSpaceData,
        content: metaMessageContent,
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
      final localAddress = getCachedWallet()!.address!;

      // update liveSpaceData by removing the current user
      if (localAddress == pCAIP10ToWallet(data.spaceCreator)) {
        // host
        data.liveSpaceData.host = AdminPeer();
      } else if (_room != null) {
        // speaker
        final speakers = <AdminPeer>[];
        for (var speaker in data.liveSpaceData.speakers) {
          if (speaker.address != localAddress) {
            speakers.add(speaker);
          }
        }
        data.liveSpaceData.speakers = speakers;
      } else {
        // listener
        final listeners = <ListenerPeer>[];
        for (var listener in data.liveSpaceData.listeners) {
          if (listener.address != localAddress) {
            listeners.add(listener);
          }
        }
        data.liveSpaceData.listeners = listeners;
      }

      // prepare messageContent of the user activity message
      String messageContent =
          _room != null ? CHAT.UA_SPEAKER_LEAVE : CHAT.UA_LISTENER_LEAVE;

      if (_room != null) {
        // turn off mic
        // TODO: Replace this with setMicrophoneState() call once we have the queue
        _isMicOn = false;
        await _room?.localParticipant?.setMicrophoneEnabled(false);

        // disconnect from the room
        _room!.disconnect();

        _room = null;
      }

      if (_playbackUrl != null) {
        _playbackUrl = null;
      }

      sendLiveSpaceData(
          messageType: MessageType.USER_ACTIVITY,
          updatedLiveSpaceData: data.liveSpaceData,
          content: messageContent,
          affectedAddresses: [localAddress],
          spaceId: data.spaceId);
      data = initSpaceData;
    } catch (e) {
      log('leave error $e');
    }

    notifyListeners();
  }

  stop() {}
}
