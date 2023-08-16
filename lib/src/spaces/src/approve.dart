import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<String?> approveSpaceRequest({
  required String senderAddress,
  String? account,
  Signer? signer,
  String? pgpPrivateKey,
  status = 'Approved',
}) {
  if (!isValidETHAddress(senderAddress) &&
      !senderAddress.startsWith("spaces:")) {
    throw Exception("Not a valid spaceId or ETH address");
  }
  return approve(
      senderAddress: senderAddress,
      account: account,
      pgpPrivateKey: pgpPrivateKey,
      signer: signer,
      status: status);
}
