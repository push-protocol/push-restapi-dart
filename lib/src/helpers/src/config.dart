import '../../../push_restapi_dart.dart';

ConfigType getConfig({
  required ENV env,
  required String blockchain,
  required String networkId,
}) {
  final blockchainSelector = '$blockchain:$networkId';
  log("getConfig: blockchainSelector: $blockchainSelector");
  final configuration = CONFIG[env]?[blockchainSelector];

  if (configuration == null) {
    throw Exception('''
  [Push SDK] - cannot determine config for 
        env: $env,
        blockchain: $blockchain,
        networkId: $networkId
''');
  }

  return configuration;
}
