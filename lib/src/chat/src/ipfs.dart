import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<IMessageIPFS?> getCID({required String cid}) async {
  try {
    final result = await http.get(path: '/v1/ipfs/$cid');
    if (result == null) {
      return null;
    }
    return IMessageIPFS.fromJson(result);
  } catch (e) {
    throw Exception('[Push SDK] - API getCID: $e');
  }
}
