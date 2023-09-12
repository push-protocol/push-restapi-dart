import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../../push_restapi_dart.dart';

Future<io.Socket?> createSocketConnection(SocketInputOptions options) async {
  try {
    final pushWSUrl = Api.getSocketAPIBaseUrls(options.env);

    String userAddressInCAIP;
    if (options.socketType == 'chat') {
      userAddressInCAIP = walletToPCAIP10(options.user);
    } else {
      userAddressInCAIP = await getCAIPAddress(address: options.user);
    }

    Map<String, dynamic>? query;
    if (options.socketType == 'notification') {
      query = {'address': userAddressInCAIP};
    } else {
      query = {'mode': 'chat', 'did': userAddressInCAIP};
    }

    final optionsBuilder = io.OptionBuilder()
        .setTransports(['websocket'])
        .setReconnectionAttempts(options.socketOptions.reconnectionAttempts)
        .setQuery(query);

    if (options.socketOptions.autoConnect == true) {
      optionsBuilder.enableAutoConnect();
    } else {
      optionsBuilder.disableAutoConnect();
    }
    if (options.socketOptions.reconnectionDelay != null) {
      optionsBuilder
          .setReconnectionDelay(options.socketOptions.reconnectionDelay as int);
    }
    if (options.socketOptions.reconnectionDelayMax != null) {
      optionsBuilder.setReconnectionDelayMax(
          options.socketOptions.reconnectionDelayMax as int);
    }

    io.Socket socket = io.io(
      pushWSUrl,
      optionsBuilder.build(),
    );
    return socket;
  } catch (e) {
    print('[PUSH-SDK] - Socket connection error: $e');
    return null;
  }
}
