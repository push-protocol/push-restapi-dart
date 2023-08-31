import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<dynamic> getIceServerConfig() async {
  const path = '/v1/turnserver/iceconfig';
  var data = await http.get(path: path);
  return data;
}
