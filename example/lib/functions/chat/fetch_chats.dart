import 'package:push_restapi_dart/push_restapi_dart.dart';

void testFetchChats() async {
  final result = await chats(
    toDecrypt: true,
  );

  print(result);
  if (result != null && result.isNotEmpty) {
    print('testFetchChats messageContent: ${result.first.msg?.messageContent}');
  }
}

testAES() {
  final ciphertextOriginal = "U2FsdGVkX18/SWOonW/UfODCpIrRFuOUKITIvRob3iE=";
  final key = "XxJNyUTlCFrrbTG";

  final decryptedMessage = "pong";

  final result = aesDecrypt(cipherText: ciphertextOriginal, secretKey: key);
  print('testAES: result $result, isCorrect: ${result == decryptedMessage}');
}

testSign() async {
  try {
    final result = await signMessageWithPGP(
        message: 'message',
        publicKey: '',
        privateKeyArmored: 'privateKeyArmored');

    print('testSign: result $result');
  } catch (e) {
    print('testSign: error ${e}');
  }
}

