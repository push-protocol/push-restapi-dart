// Define the class in Dart
import 'package:push_restapi_dart/push_restapi_dart.dart';

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

Future<dynamic> getAliasInfo({required GetAliasInfoOptionsType options}) async {
  final alias = ALIAS_CHAIN_ID[options.alias.toString()]?[options.env];

  final apiEndpoint = "/v1/alias/$alias/channel";
  return await http.get(
    path: apiEndpoint,
    baseUrl: Api.getAPIBaseUrls(options.env),
  );
}
