import 'package:livekit_client/livekit_client.dart';

import '../../../../push_restapi_dart.dart';

final _livepeerBaseUrl = 'https://livepeer.studio/api';
String _livepeerApiKey = '4217cd75-ce67-49af-a6dd-aa1581f7d651';
setLivePeerKey(String key) {
  _livepeerApiKey = key;
}

Future<LivepeerStreamDetails> createStreamService({
  required String spaceName,
}) async {
  final result = await http.post(
    baseUrl: _livepeerBaseUrl,
    path: '/stream',
    headers: {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $_livepeerApiKey',
    },
    data: {
      'name': spaceName,
      'record': true,
    },
  );

  return LivepeerStreamDetails.fromJson(result);
}

Future<String> createLivePeerRoom() async {
  final result = await http.post(
    baseUrl: _livepeerBaseUrl,
    path: '/room',
    headers: {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $_livepeerApiKey',
    },
    data: {},
  );

  return result['id'];
}

Future<void> startLiveStream(
    {required String roomId, required String streamId}) async {
  try {
    final result = await http.post(
        baseUrl: _livepeerBaseUrl,
        path: '/room/$roomId/egress',
        headers: {
          'Content-Type': 'application/json',
          "Authorization": 'Bearer $_livepeerApiKey',
        },
        data: {
          "streamId": streamId
        });
    log('startLiveStream result: $result');
  } catch (error) {
    log('startLiveStream  $error');
    throw Exception("Error in starting live stream");
  }
}

Future<LivepeerParticipant> _addLivepeerRoomParticipant({
  required String roomId,
  required String participantName,
}) async {
  final result = await http.post(
    baseUrl: _livepeerBaseUrl,
    path: '/room/$roomId/user',
    headers: {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $_livepeerApiKey',
    },
    data: {
      "name": participantName,
    },
  );

  return LivepeerParticipant.fromJson(result);
}

Future<Room?> connectToRoomAndPublishAudio({
  required String url,
  required String token,
  bool autoOnMic = false,
}) async {
  try {
    final roomOptions = RoomOptions(
      adaptiveStream: true,
    );

    final room = Room();

    await room.connect(url, token, roomOptions: roomOptions);
    if (autoOnMic) {
      room.localParticipant!.setMicrophoneEnabled(true);
    }
    return room;
  } catch (e) {
    return null;
  }
}

String _extractWebSocketUrlFromJoinUrl(String joinUrl) {
  final url = joinUrl.split('=')[1];

  return url.replaceAll('&token', '');
}

Future<Room?> addSpeakingParticipant({
  required String roomId,
  required String participantName,
  bool autoOnMic = false,
}) async {
  ///add local user as participant
  final participant = await _addLivepeerRoomParticipant(
    roomId: roomId,
    participantName: participantName,
  );

  final url = _extractWebSocketUrlFromJoinUrl(participant.joinUrl!);

  return connectToRoomAndPublishAudio(
    url: url,
    token: participant.token!,
    autoOnMic: autoOnMic,
  );
}
