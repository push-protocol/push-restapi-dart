import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<dynamic> getIceServerConfig() {
  const path = '/v1/turnserver/iceconfig';
  var data = http.get(path: path);
  return data;
}
