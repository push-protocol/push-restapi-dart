import '../../../push_restapi_dart.dart';

class Alias {
  final ENV env;
  final Signer? signer;

  Alias({
    required this.env,
    this.signer,
  });

  Future<dynamic> info(AliasOptions options) async {
    return getAliasInfo(
      options: GetAliasInfoOptionsType(
        alias: options.alias,
        aliasChain: options.aliasChain,
        env: env,
      ),
    );
  }

  /// @description verifies an alias address of a channel
  /// @param {string} channelAddress - channelAddress to be verified
  /// @param {AliasInfoOptions} options - options related to alias
  /// @returns the transaction hash if the transaction is successfull
  Future<dynamic> verify({required String channelAddress}) async {
    ///TODO implement Alias.verify
    throw UnimplementedError();
  }
}

class AliasOptions {
  // Properties
  String alias;
  ALIAS_CHAIN aliasChain;

  // Constructor
  AliasOptions({
    required this.alias,
    required this.aliasChain,
  });
}
