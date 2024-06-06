import '../../../push_restapi_dart.dart';

/// @description - fetches alias information
/// @param {AliasOptions} options - options related to alias
/// @returns Alias details
Future<dynamic> getAliasInfo({required GetAliasInfoOptionsType options}) async {
  final alias = ALIAS_CHAIN_ID[options.alias.toString()]?[options.env];

  final apiEndpoint = "/v1/alias/$alias/channel";
  return await http.get(
    path: apiEndpoint,
    baseUrl: Api.getAPIBaseUrls(options.env),
  );
}

class GetAliasInfoOptionsType {
  // Properties
  String alias;
  ALIAS_CHAIN aliasChain;
  ENV env;

  // Constructor
  GetAliasInfoOptionsType({
    required this.alias,
    required this.aliasChain,
    this.env = ENV.prod,
  });
}
