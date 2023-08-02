import 'package:push_restapi_dart/push_restapi_dart.dart';

void testFetchRequests() async {
  final result = await requests(toDecrypt: true);

  print(result);
  if (result != null && result.isNotEmpty) {
    print(
        'testFetchRequests messageContent: ${result.first.msg?.messageContent}');
  }
}

void testApproveRequests() async {
  final result = await approve(senderAddress: 'senderAddress');

  print(result);
}
