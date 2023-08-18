import '../../../push_restapi_dart.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

typedef SetDataFunction = VideoCallData Function(VideoCallData);

final VideoCallData initVideoCallData = VideoCallData();

class VideoCallStateNotifier extends StateNotifier<VideoCallData> {
  VideoCallStateNotifier() : super(initVideoCallData);

  void setData(SetDataFunction fn) {
    final newState = fn(state);
    state = newState;
  }
}

final videoCallStateProvider =
    StateNotifierProvider<VideoCallStateNotifier, VideoCallData>(
  (ref) => VideoCallStateNotifier(),
);

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

  Future<void> create(VideoCreateInputOptions? options) async {
    bool audio = options?.audio ?? true;
    bool video = options?.video ?? true;
    dynamic stream = options?.stream;
    try {
      final localStream = stream ??
          await rtc.navigator.mediaDevices.getUserMedia({
            // for frontend
            'video': video,
            'audio': audio,
          });
      providerContainer
          .read(videoCallStateProvider.notifier)
          .setData((oldData) {
        final newLocal = Local(
          stream: localStream,
          audio: audio,
          video: video,
          address: oldData.local!.address,
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
}
