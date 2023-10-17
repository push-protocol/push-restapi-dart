import 'package:flutter_test/flutter_test.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

void main() {
  group('aes functions', () {
    test('.generateRandomSecret', () {
      expect(generateRandomSecret(-1), '');
      expect(generateRandomSecret(6).length, 6);

      final secret1 = generateRandomSecret(6);
      final secret2 = generateRandomSecret(6);

      expect(secret1 == secret2, false);
    });
    test('.genRandomWithNonZero', () {
      expect(genRandomWithNonZero(6).length, 6);

      final secret1 = genRandomWithNonZero(6);
      final secret2 = genRandomWithNonZero(6);

      expect(secret1 == secret2, false);
    });

    test('.createUint8ListFromString', () {
      final plainText = 'push.org';
      final bytesValue = [112, 117, 115, 104, 46, 111, 114, 103];
      expect(createUint8ListFromString(plainText), bytesValue);
    });

    test('aes decrypt encrypt', () async {
      final plainText = 'push.org';
      final secretKey = 'flutter';
      final cipherText =
          await aesEncrypt(plainText: plainText, secretKey: secretKey);
      final decipherText =
          aesDecrypt(cipherText: cipherText, secretKey: secretKey);
      expect(decipherText == plainText, true);
    });
    test('aes encrypt error', () async {
      expect(() => aesDecrypt(cipherText: '231212', secretKey: '1212'),
          throwsA(isA<Exception>()));
    });
  });
}
