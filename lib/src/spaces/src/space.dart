// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

import 'helpers/live_peer.dart';
import 'on_receive_meta_message_for_space.dart';
import 'initialize.dart';
import 'join.dart';
import 'update_space_meta.dart';

import '../../../push_restapi_dart.dart';

typedef SetDataFunction = SpaceData Function(SpaceData);

LiveSpaceData initLiveSpaceData = LiveSpaceData(
  host: AdminPeer(),
  speakers: [],
  listeners: [],
);

SpaceData _initSpaceData = SpaceData(
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

class PushSpaceNotifier extends ChangeNotifier {
  PushSpaceNotifier() {
    data = _initSpaceData;
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
  }) async {
    final update = await updateSpaceMeta(
      meta: meta,
      spaceId: data.spaceId,
    );

    setData((p0) {
      return SpaceData.fromSpaceDTO(update, data.liveSpaceData);
    });
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
      _playbackUrl = null;
      if (_room != null) {
        // turn off mic
        // TODO: Replace this with setMicrophoneState() call once we have the queue
        _isMicOn = false;
        await _room?.localParticipant?.setMicrophoneEnabled(false);

        // disconnect from the room
        _room!.disconnect();

        // fire a user activity message signaling that the user has left the space
        final localAddress = getCachedWallet()!.address!;
        final spaceData = data;

        String metaMessageContent = CHAT.UA_SPEAKER_LEAVE;

        if (localAddress == pCAIP10ToWallet(spaceData.spaceCreator)) {
          spaceData.liveSpaceData.host = AdminPeer();
        } else {
          final speakers = <AdminPeer>[];
          for (var speaker in spaceData.liveSpaceData.speakers) {
            if (speaker.address != localAddress) {
              speakers.add(speaker);
            }
          }
          spaceData.liveSpaceData.speakers = speakers;
        }

        sendLiveSpaceData(
            messageType: MessageType.USER_ACTIVITY,
            updatedLiveSpaceData: spaceData.liveSpaceData,
            content: metaMessageContent,
            affectedAddresses: [localAddress],
            spaceId: spaceData.spaceId);

        data = _initSpaceData;
      }

      _room = null;
    } catch (e) {
      log('leave error $e');
    }

    notifyListeners();
  }

  stop() {}

  sendReaction({required String reaction}) async {
    final reactionMessage = ReactionMessage(
        // Note: For spaces a reaction is a general reaction, not referenced to a message
        // This is not getting added to the idempotent state
        reference: '',
        content: reaction);

    final options = ChatSendOptions(
      message: reactionMessage,
      receiverAddress: data.spaceId,
    );

    await send(options);
  }
}
