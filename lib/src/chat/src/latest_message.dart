import 'package:push_restapi_dart/push_restapi_dart.dart';

///Get the latest chat message
Future<Message?> latest({
  required String threadhash,
  String? accountAddress,
  String? pgpPrivateKey,
  bool toDecrypt = false,
}) async {
  return (await history(
    threadhash: threadhash,
    accountAddress: accountAddress,
    pgpPrivateKey: pgpPrivateKey,
    limit: 1,
    toDecrypt: toDecrypt,
  ))
      ?.first;
}
