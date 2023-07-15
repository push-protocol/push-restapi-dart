import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:push_restapi_dart/push_restapi_dart.dart';

String generateRandomSecret(int length) {
  final random = math.Random.secure();
  final characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final charactersLength = characters.length;
  final buffer = StringBuffer();
  for (var i = 0; i < length; i++) {
    buffer.write(characters[random.nextInt(charactersLength)]);
  }
  return buffer.toString();
}

// AES 256 bits encryption with pkcs7 padding
Future<String> aesEncrypt(
    {required String plainText, required String secretKey}) async {
  // specifing the AES mode and key bit length
  final algorithm = AesCbc.with256bits(
    macAlgorithm: MacAlgorithm.empty,
  );

  // encrypt
  final secretBox = await algorithm.encryptString(
    plainText,
    secretKey: await algorithm.newSecretKeyFromBytes(utf8.encode(secretKey)),
  );

  // return the cipher text in string form
  return utf8.decode(secretBox.cipherText);
}

String aesDecrypt({required String cipherText, required String secretKey}) {
  try {
    Uint8List encryptedBytesWithSalt = base64.decode(cipherText);

    Uint8List encryptedBytes =
        encryptedBytesWithSalt.sublist(16, encryptedBytesWithSalt.length);
    final salt = encryptedBytesWithSalt.sublist(8, 16);
    var keyndIV = deriveKeyAndIV(secretKey, salt);
    final key = encrypt.Key(keyndIV.first);
    final iv = encrypt.IV(keyndIV.last);

    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
    final decrypted =
        encrypter.decrypt64(base64.encode(encryptedBytes), iv: iv);
    return decrypted;
  } catch (error) {
    log('decryptAESCryptoJS:error $error');
    rethrow;
  }
}

List<Uint8List> deriveKeyAndIV(String passphrase, Uint8List salt) {
  var password = createUint8ListFromString(passphrase);
  Uint8List concatenatedHashes = Uint8List(0);
  Uint8List currentHash = Uint8List(0);
  bool enoughBytesForKey = false;
  Uint8List preHash = Uint8List(0);

  while (!enoughBytesForKey) {
    if (currentHash.isNotEmpty) {
      preHash = Uint8List.fromList(currentHash + password + salt);
    } else {
      preHash = Uint8List.fromList(password + salt);
    }
    final p = md5.convert(List.from(preHash));

    currentHash = Uint8List.fromList(p.bytes);
    concatenatedHashes = Uint8List.fromList(concatenatedHashes + currentHash);
    if (concatenatedHashes.length >= 48) enoughBytesForKey = true;
  }

  var keyBtyes = concatenatedHashes.sublist(0, 32);
  var ivBtyes = concatenatedHashes.sublist(32, 48);
  return [keyBtyes, ivBtyes];
}

Uint8List createUint8ListFromString(String s) {
  var ret = Uint8List(s.length);
  for (var i = 0; i < s.length; i++) {
    ret[i] = s.codeUnitAt(i);
  }
  return ret;
}
