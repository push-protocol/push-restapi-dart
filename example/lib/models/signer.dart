import 'dart:convert';
import 'dart:typed_data';

import 'package:ethers/signers/wallet.dart' as ethers;
import 'package:push_restapi_dart/push_restapi_dart.dart' as push;
import 'package:eth_sig_util/eth_sig_util.dart' as eth_sig;

class SignerPrivateKey extends push.Signer {
  final ethers.Wallet ethersWallet;

  final String address;

  SignerPrivateKey({required this.ethersWallet, required this.address});

  @override
  String getAddress() {
    return address;
  }

  @override
  Future<String> getEip191Signature(String message) async {
    try {
      var m = utf8.encode(message);

      String signature = eth_sig.EthSigUtil.signPersonalMessage(
          privateKey: ethersWallet.privateKey, message: Uint8List.fromList(m));
      return signature;
    } catch (e) {
      print('override: getEip191Signature: error$e');
      return message;
    }
  }

  @override
  Future<String> getEip712Signature(String message) async {
    throw UnimplementedError();
  }

  @override
  Future<String> signMessage(String message) async {
    try {
      var m = utf8.encode(message);

      String signature = eth_sig.EthSigUtil.signMessage(
          privateKey: ethersWallet.privateKey, message: Uint8List.fromList(m));
      return signature;
    } catch (e) {
      return message;
    }
  }

  @override
  getChainId() {
    if (ethersWallet.hdNode?.chainCode == null) {
      throw Exception('SignerPrivateKey getChainId(): Invaid Chain Code');
    }
    return ethersWallet.hdNode?.chainCode ?? '';
  }

  @override
  Future<String> signTypedData({domain, types, value}) {
    throw UnimplementedError();
  }
}
