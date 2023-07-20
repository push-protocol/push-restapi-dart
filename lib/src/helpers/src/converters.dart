import 'dart:convert';
import '../../../push_restapi_dart.dart';

String walletToPCAIP10(String account) {
  if (isValidCAIP10NFTAddress(account) || account.contains('eip155:')) {
    return account;
  }
  return 'eip155:$account';
}

String pCAIP10ToWallet(String wallet) {
  if (isValidCAIP10NFTAddress(wallet)) return wallet;
  wallet = wallet.replaceFirst('eip155:', '');
  return wallet;
}

String getPublicKeyFromString(String pgpPublicKeyString) {
  if (pgpPublicKeyString.isEmpty) {
    return pgpPublicKeyString;
  }
  dynamic pgpPublicKeyJson;
  try {
    pgpPublicKeyJson = jsonDecode(pgpPublicKeyString);
    pgpPublicKeyJson = pgpPublicKeyJson["key"] ?? pgpPublicKeyString;
    return pgpPublicKeyJson;
  } catch (error) {
    return pgpPublicKeyString;
  }
}