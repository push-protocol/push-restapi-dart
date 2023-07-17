import 'package:openpgp/openpgp.dart';

String removeVersionFromPublicKey(String key) {
  List<String> lines = key.split('\n');

  lines.removeWhere((line) => line.trim().startsWith('Version:'));

  return lines.join('\n');
}

Future<KeyPair> generateKeyPair() async {
  try {
    print("here");
    try{
    final keyOptions = KeyOptions()
      ..algorithm = Algorithm.RSA
      ..rsaBits = 2048;
      

    final keyPair = await OpenPGP.generate(
        options: Options()
          ..keyOptions = keyOptions);
    keyPair.privateKey = removeVersionFromPublicKey(keyPair.privateKey);
    keyPair.publicKey = removeVersionFromPublicKey(keyPair.publicKey);
    return keyPair;
    } catch(error){
      print("error");
      throw Exception(error);
    }
  } catch (error) {
    print(error);
    throw Exception(error);
  }
}

Future<String> sign(
    {required String message,
    required String publicKey,
    required String privateKey}) async {
  return await OpenPGP.sign(message, publicKey, privateKey, "");
}

Future<String> pgpEncrypt({
  required String plainText,
  required List<String> keys,
}) async {
  final combinedPGPKey = keys.join();

  final encrypted = await OpenPGP.encrypt(
    plainText,
    combinedPGPKey,
  );

  return encrypted;
}

pgpDecrypt({
  required String cipherText,
  required String privateKeyArmored,
  required String signatureArmored,
}) async {
//TODO implement pgpDecrypt
}
