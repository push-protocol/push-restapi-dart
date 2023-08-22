import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../push_restapi_dart.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

typedef SetDataFunction = VideoCallData Function(VideoCallData);

final VideoCallData initVideoCallData = VideoCallData();

class VideoCallStateNotifier extends ChangeNotifier {
  VideoCallStateNotifier() {
    videoCallData = VideoCallData();
  }
  // VideoCallStateNotifier() : super(initVideoCallData);

  late VideoCallData videoCallData;

  void setData(SetDataFunction fn) {
    final newState = fn(videoCallData);
    videoCallData = newState;
    log('setData: $videoCallData');
  }

  Future<void> create(VideoCreateInputOptions? options) async {
    bool audio = options?.audio ?? true;
    bool video = options?.video ?? true;
    rtc.MediaStream? stream = options?.stream;

    try {
      final rtc.MediaStream localStream = stream ??
          await rtc.navigator.mediaDevices.getUserMedia({
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

  Future<void> request(VideoRequestInputOptions options) async {}
}

final videoCallStateProvider =
    ChangeNotifierProvider<VideoCallStateNotifier>((ref) {
  return VideoCallStateNotifier();
});

class Video {
  late VideoCallData data;
  final Signer signer;
  final int chainId;
  final String pgpPrivateKey;
  final int callType;
  late Function(MediaStream receivedStream, String senderAddress, bool? audio)
      onReceiveStream;
  Map<String, dynamic> peerInstances = {};

  Video({
    required this.signer,
    required this.chainId,
    required this.pgpPrivateKey,
    required this.callType,
    required setData,
    required data,
    required this.onReceiveStream,
  }) {
    onReceiveStream = onReceiveStream;

    // Initialize the react state
    final container = ProviderContainer();
    container.read(videoCallStateProvider);

    // Initialize the class variable
    data = initVideoCallData;

    // Set the state updating function
    setData = (SetDataFunction fn) {
      container.read(videoCallStateProvider.notifier).setData(fn);
    };
  }
}
