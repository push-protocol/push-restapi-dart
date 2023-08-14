
import '../../../push_restapi_dart.dart';

final VideoCallData initVideoCallData = VideoCallData();

class Video {
  final Signer signer;
  final int chainId;
  final String pgpPrivateKey;
  final int callType;
  final Function(MediaStream receivedStream, String senderAddress, bool? audio)
      onReceiveStream;

  Map<String, dynamic> peerInstances = {};

  final VideoCallData data;
  final Function(VideoCallData data) setData;

  Video({
    required this.signer,
    required this.chainId,
    required this.pgpPrivateKey,
    required this.callType,
    required this.onReceiveStream,
    required this.data,
    required this.setData,
  });

  Future create(VideoCreateInputOptions options) async {}
}
