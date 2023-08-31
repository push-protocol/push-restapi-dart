import 'package:flutter_webrtc/flutter_webrtc.dart';

void restartVideoStream(MediaStream stream) {
  print('RESTART LOCAL STREAM');
  List<MediaStreamTrack> vidTracks = stream.getVideoTracks();
  for (var track in vidTracks) {
    track.enabled = true;
  }
}

void stopVideoStream(MediaStream stream) {
  print('STOP LOCAL STREAM');
  List<MediaStreamTrack> vidTracks = stream.getVideoTracks();
  for (var track in vidTracks) {
    track.enabled = false;
  }
}

void restartAudioStream(MediaStream stream) {
  print('RESTART AUDIO');
  List<MediaStreamTrack> audTracks = stream.getAudioTracks();
  for (var track in audTracks) {
    track.enabled = true;
  }
}

void stopAudioStream(MediaStream stream) {
  print('STOP AUDIO');
  List<MediaStreamTrack> audTracks = stream.getAudioTracks();
  for (var track in audTracks) {
    track.enabled = false;
  }
}

void endStream(MediaStream stream) {
  print("END STREAM");
  List<MediaStreamTrack> tracks = stream.getTracks();
  for (var track in tracks) {
    track.stop();
  }
}
