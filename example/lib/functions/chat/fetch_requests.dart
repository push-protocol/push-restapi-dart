import 'package:push_restapi_dart/push_restapi_dart.dart';

void testFetchRequests() async {
  final result = await requests(
      toDecrypt: false,
      accountAddress: 'eip155:0x2E06acc49D2B0724a3681B6b0C264a74786C98d5');

  print(result);
  if (result != null && result.isNotEmpty) {
    print(
        'testFetchRequests messageContent: ${result.first.msg?.messageContent}');
  }
}
