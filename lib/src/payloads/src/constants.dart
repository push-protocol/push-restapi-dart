// ignore_for_file: constant_identifier_names, camel_case_types, non_constant_identifier_names

class CHAIN_ID_TO_SOURCE {
  static const Map<int, String> CHAIN = {
    1: 'ETH_MAINNET',
    5: 'ETH_TEST_GOERLI',
    137: 'POLYGON_MAINNET',
    80001: 'POLYGON_TEST_MUMBAI',
    56: 'BSC_MAINNET',
    97: 'BSC_TESTNET',
    10: 'OPTIMISM_MAINNET',
    420: 'OPTIMISM_TESTNET',
    1442: 'POLYGON_ZK_EVM_TESTNET',
    1101: 'POLYGON_ZK_EVM_MAINNET',
  };
  static const String DEFAULT_SOURCE = 'ETH_MAINNET';
}

class SOURCE_TYPES {
  static const String ETH_MAINNET = 'ETH_MAINNET';
  static const String ETH_TEST_GOERLI = 'ETH_TEST_GOERLI';
  static const String POLYGON_MAINNET = 'POLYGON_MAINNET';
  static const String POLYGON_TEST_MUMBAI = 'POLYGON_TEST_MUMBAI';
  static const String BSC_MAINNET = 'BSC_MAINNET';
  static const String BSC_TESTNET = 'BSC_TESTNET';
  static const String OPTIMISM_MAINNET = 'OPTIMISM_MAINNET';
  static const String OPTIMISM_TESTNET = 'OPTIMISM_TESTNET';
  static const String POLYGON_ZK_EVM_TESTNET = 'POLYGON_ZK_EVM_TESTNET';
  static const String POLYGON_ZK_EVM_MAINNET = 'POLYGON_ZK_EVM_MAINNET';
  static const String THE_GRAPH = 'THE_GRAPH';
  static const String PUSH_VIDEO = 'PUSH_VIDEO';
}

enum IDENTITY_TYPE {
  MINIMAL,
  IPFS,
  DIRECT_PAYLOAD,
  SUBGRAPH,
}

class NOTIFICATION_TYPE {
  static const NOTIFICATION_TYPE BROADCAST = NOTIFICATION_TYPE._(1);
  static const NOTIFICATION_TYPE TARGETTED = NOTIFICATION_TYPE._(3);
  static const NOTIFICATION_TYPE SUBSET = NOTIFICATION_TYPE._(4);

  final int value;

  const NOTIFICATION_TYPE._(this.value);

  @override
  String toString() {
    return '$value';
  }
}

enum ADDITIONAL_META_TYPE {
  CUSTOM,
  PUSH_VIDEO,
  PUSH_SPACE,
}

class VIDEO_CALL_TYPE {
  static const int PUSH_VIDEO = 1;
  static const int PUSH_SPACE = 2;
}

enum SPACE_REQUEST_TYPE {
  JOIN_SPEAKER, // space has started, join as a speaker
  ESTABLISH_MESH, // request to establish mesh connection
  INVITE_TO_PROMOTE, // host invites someone to be promoted as the speaker
  REQUEST_TO_PROMOTE, // someone requests the host to be promoted to a speaker
}

enum SPACE_ACCEPT_REQUEST_TYPE {
  ACCEPT_JOIN_SPEAKER,
  ACCEPT_INVITE,
  ACCEPT_PROMOTION,
}

enum SPACE_DISCONNECT_TYPE {
  STOP, // space is stopped/ended
  LEAVE, // speaker leaves a space
}

enum SPACE_INVITE_ROLES {
  CO_HOST,
  SPEAKER,
}

enum SPACE_ROLES {
  HOST,
  CO_HOST,
  SPEAKER,
  LISTENER,
}

const String DEFAULT_DOMAIN = 'push.org';
