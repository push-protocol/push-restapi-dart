import 'package:push_restapi_dart/push_restapi_dart.dart';
import 'package:test/test.dart';
import 'dart:convert';
import 'package:cryptography/cryptography.dart';

void main() {
  group('A group of tests', () {
    // setUp(() {
    //   // Additional setup goes here.
    // });

    // test('First Test', () {});

    test('encryption decryption testing', () async {
      final testPgpKey = r'''
      ''';
      String nonce = "dfc04cc8782887903338f7e3";
      String salt =
          "8df3cc0bbc7434b2ed7ca674b13d6c1180a5300fec3f09ad6ad9f8c8cc2a26ba";
      String secret =
          "eip191:0x79725b6918f31cf01da680c8c11c8c6a208130c35459d64032444b7ba6b3b2cc447671d6c3be264fdfa08d5114cead9ca383f683809ec69f3c70c7101fc253221c";
      final secretBytes = hexToBytesInternal(secret);
      final saltBytes = hexToBytes(salt);
      final algorithm = AesGcm.with256bits(nonceLength: 32);
      final key = await hkdf(secretBytes, saltBytes);
      final data = utf8.encode(testPgpKey);
      final secretBox = await algorithm.encrypt(
        data,
        secretKey: key,
        nonce: hexToBytes(nonce),
      );
      List<int> combined = [];
      combined.addAll(secretBox.cipherText);
      combined.addAll(secretBox.mac.bytes);
      bytesToHex(combined);
      final cipherBytes = combined;
      final cypherBytesSubstring =
          cipherBytes.sublist(0, cipherBytes.length - 16);
      final mac = cipherBytes.sublist(cipherBytes.length - 16);
      // Construct the secret box
      final secretBox2 = SecretBox(cypherBytesSubstring,
          nonce: hexToBytes(nonce), mac: Mac(mac));

      // Decrypt
      final decryptedText = await algorithm.decrypt(
        secretBox2,
        secretKey: key,
      );

      print((decryptedText));
    });
  });
}
