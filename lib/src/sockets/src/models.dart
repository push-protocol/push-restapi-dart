import '../../../push_restapi_dart.dart';

class SocketInputOptions {
  final String user;
  final ENV env;
  final String socketType;
  final SocketOptions socketOptions;

  SocketInputOptions({
    required this.user,
    required this.env,
    required this.socketType,
    required this.socketOptions,
  }) {
    assert(socketType == SOCKETTYPES.NOTIFICATION ||
        socketType == SOCKETTYPES.CHAT);
  }
}

class SocketOptions {
  final bool autoConnect;
  final int reconnectionAttempts;
  final int? reconnectionDelay;
  final int? reconnectionDelayMax;

  SocketOptions(
      {this.autoConnect = true,
      this.reconnectionAttempts = 5,
      this.reconnectionDelay,
      this.reconnectionDelayMax});
}
