import 'package:push_restapi_dart/src/channels/src/get_delegates.dart';

import '../../../push_restapi_dart.dart';

class Delegate {
  final ENV env;
  final String? account;

  Delegate({required this.env, required this.account});

  Future<dynamic> get(ChannelInfoOptions? options) async {
    try {
      String? channel = options?.channel ??
          (account != null
              ? getFallbackETHCAIPAddress(env: env, address: account!)
              : null);

      if (channel != null) {
        if (!validateCAIP(channel)) {
          channel = getFallbackETHCAIPAddress(env: env, address: channel);
        }
      }

      return getDelegates(channel: channel!);
    } catch (error) {
      throw Exception('Push SDK Error: API : delegate::get : $error');
    }
  }
}
