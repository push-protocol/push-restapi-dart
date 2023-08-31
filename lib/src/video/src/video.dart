// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../push_restapi_dart.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

final PushVideoCallProvider =
    ChangeNotifierProvider<VideoCallStateNotifier>((ref) {
  return VideoCallStateNotifier();
});

typedef SetVideoDataFunction = VideoCallData Function(VideoCallData);

VideoCallData initVideoCallData = VideoCallData();

class VideoCallStateNotifier extends ChangeNotifier {
  late VideoCallData data;
  late Signer? signer;
  late int chainId;
  late String? pgpPrivateKey;
  late int callType;
  late Function(MediaStream receivedStream, String senderAddress, bool? audio)
      onReceiveStream;

  // {
  //   address: {
  //     peerConnection: RTCPeerConnection,
  //     iceCandidates: RTCIceCandidate[]
  //   }
  // }
  final Map<String, Map<String, dynamic>> _rtcPeer = {};

  initializeVideo({
    Signer? signer,
    required int chainId,
    String? pgpPrivateKey,
    required int callType,
    required VideoCallData data,
    required Function(
            MediaStream receivedStream, String senderAddress, bool? audio)
        onReceiveStream,
  }) {
    this.signer = signer ?? getCachedWallet()?.signer;
    this.chainId = chainId;
    this.pgpPrivateKey = pgpPrivateKey ?? getCachedWallet()?.pgpPrivateKey;
    videoCallData = data;
    this.onReceiveStream = onReceiveStream;
    notifyListeners();
  }

  VideoCallStateNotifier() {
    videoCallData = VideoCallData();
  }
  // VideoCallStateNotifier() : super(initVideoCallData);

  late VideoCallData videoCallData;

  void setData(SetVideoDataFunction fn) {
    final newState = fn(videoCallData);
    videoCallData = newState;
    log('setData: $videoCallData');
  }

  Future<void> create(VideoCreateInputOptions? options) async {
    bool audio = options?.audio ?? true;
    bool video = options?.video ?? true;
    MediaStream? stream = options?.stream;

    try {
      final MediaStream localStream = stream ??
          await navigator.mediaDevices.getUserMedia({
            // for frontend
            'video': video,
            'audio': audio,
          });
      setData((oldData) {
        final String address = oldData.local?.address ?? getCachedUser()!.did!;
        final newLocal = Local(
          stream: localStream,
          audio: audio,
          video: video,
          address: address,
        );
        return VideoCallData(
          meta: oldData.meta,
          local: newLocal,
          incoming: oldData.incoming,
        );
      });
    } catch (err) {
      print('error in create: $err');
    }
  }

  Future<void> request({
    required String senderAddress,
    required List<String> recipientAddresses,
    required String chatId,
    Object? details,
  }) async {
    print(
        "senderAddress $senderAddress \n recipientAddresses $recipientAddresses \n chatId $chatId details $details");

    for (final recipientAddress in recipientAddresses) {
      try {
        // TODO: Set video call data with status INITIALIZED

        // TODO: Get ice server config from get_ice_server_config
        RTCPeerConnection peer = await createPeerConnection({
          'iceServers':
              // replace the below array with decrypted turn server API result
              [
            {
              'urls': [
                'stun:stun1.l.google.com:19302',
                'stun:stun2.l.google.com:19302'
              ]
            }
          ]
        });

        _rtcPeer[recipientAddress] = {
          'peerConnection': peer,
          'iceCandidates': []
        };

        // add local stream's tracks to RTC connection
        // this.data.local.stream!.getTracks().forEach((track) {
        //   peer.addTrack(track, this.data.local.stream!);
        // });

        // listen for remotePeer mediaTrack event
        peer.onTrack = (event) {
          // save the incoming stream (event.streams[0]) in the state
        };

        // listen for local iceCandidate and add it to the list of IceCandidates
        peer.onIceCandidate = (RTCIceCandidate candidate) =>
            _rtcPeer[recipientAddress]?['iceCandidates'].add(candidate);

        // create SDP Offer
        RTCSessionDescription offer = await peer.createOffer();
        // set SDP offer as localDescription for peerConnection
        await peer.setLocalDescription(offer);

        // send a notification containing SDP offer
        // sendVideoCallNotification(
        //   // TODO: fill this object
        //   {
        //       signer: ,
        //       chainId: ,
        //       pgpPrivateKey: ,
        //     }, {
        //       senderAddress,
        //       recipientAddress,
        //       status: VideoCallStatus.INITIALIZED,
        //       chatId,
        //       signalData: offer.toMap(),
        //       env: //,
        //       callType: //,
        //       callDetails: details,
        //     })
      } catch (err) {
        print('error in request $err');
      }
    }
  }
}
