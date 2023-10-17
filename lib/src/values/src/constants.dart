// ignore_for_file: constant_identifier_names, camel_case_types, non_constant_identifier_names

class ENCRYPTION_TYPE {
  static const PGP_V1 = 'x25519-xsalsa20-poly1305';
  static const PGP_V2 = 'aes256GcmHkdfSha256';
  static const PGP_V3 = 'eip191-aes256-gcm-hkdf-sha256';
  static const NFTPGP_V1 = 'pgpv1:nft';

  static isValidEncryptionType(String type) {
    return [PGP_V1, PGP_V2, PGP_V3, NFTPGP_V1].contains(type);
  }
}

class Pagination {
  static const INITIAL_PAGE = 1;
  static const LIMIT = 10;
  static const LIMIT_MIN = 1;
  static const LIMIT_MAX = 50;
}

class Constants {
  static const Map<String, dynamic> PAGINATION = {
    'INITIAL_PAGE': 1,
    'LIMIT': 10,
    'LIMIT_MIN': 1,
    'LIMIT_MAX': 50,
  };
  static const int DEFAULT_CHAIN_ID = 5;
  static const int DEV_CHAIN_ID = 99999;
  static const List<int> NON_ETH_CHAINS = [
    137,
    80001,
    56,
    97,
    10,
    420,
    1442,
    1101
  ];
  static const List<int> ETH_CHAINS = [1, 5];
  static const String ENC_TYPE_V1 = 'x25519-xsalsa20-poly1305';
  static const String ENC_TYPE_V2 = 'aes256GcmHkdfSha256';
  static const String ENC_TYPE_V3 = 'eip191-aes256-gcm-hkdf-sha256';
  static const String ENC_TYPE_V4 = 'pgpv1:nft';
}

class MessageType {
  static const TEXT = 'Text';
  static const VIDEO = 'Video';
  static const AUDIO = 'Audio';
  static const IMAGE = 'Image';
  static const FILE = 'File';
  static const MEDIA_EMBED = 'MediaEmbed';
  static const META = 'Meta';
  static const REACTION = 'Reaction';
  static const COMPOSITE = 'Composite';
  static const REPLY = 'Reply';
  static const RECEIPT = 'Receipt';
  static const USER_ACTIVITY = 'UserActivity';
  static const INTENT = 'Intent';
  static const PAYMENT = 'Payment';

  /// @deprecated - Use MediaEmbed Instead
  static const GIF = 'GIF';

  static isValidMessageType(String type) {
    return [
      TEXT,
      VIDEO,
      AUDIO,
      IMAGE,
      FILE,
      MEDIA_EMBED,
      META,
      REACTION,
      COMPOSITE,
      REPLY,
      USER_ACTIVITY,
      PAYMENT,
      INTENT,
      RECEIPT
    ].contains(type);
  }
}

final Map<String, dynamic> CHAT = {
  'META': {
    'GROUP': {
      'CREATE': 'CREATE_GROUP',
      'MEMBER': {
        'ADD': 'ADD_MEMBER',
        'REMOVE': 'REMOVE_MEMBER',
        'PRIVILEGE': 'ASSIGN_MEMBER_PRIVILEGE',
      },
      'ADMIN': {
        'PRIVILEGE': 'ASSIGN_ADMIN_PRIVILEGE',
      },
      'UPDATE': 'UPDATE_GROUP',
      'PROFILE': {
        'UPDATE': 'UPDATE_GROUP_PROFILE',
      },
      'META': {
        'UPDATE': 'UPDATE_GROUP_META',
      },
      'USER': {
        'INTERACTION': 'USER_INTERACTION',
      },
    },
    'SPACE': {
      'CREATE': 'CREATE_SPACE',
      'START': "START_SPACE", //
      'LISTENER': {
        'ADD': 'ADD_LISTENER',
        'REMOVE': 'REMOVE_LISTENER',
        'PRIVILEGE': 'ASSIGN_LISTENER_PRIVILEGE',
      },
      'SPEAKER': {
        'PRIVILEGE': 'ASSIGN_SPEAKER_PRIVILEGE',
      },
      'COHOST': {
        'PRIVILEGE': 'ASSIGN_COHOST_PRIVILEGE',
      },
    },
  },
  'REACTION': {
    'THUMBSUP': '\u{1F44D}',
    'THUMBSDOWN': '\u{1F44E}',
    'HEART': '\u{2764}\u{FE0F}',
    'CLAP': '\u{1F44F}',
    'LAUGH': '\u{1F602}',
    'SAD': '\u{1F622}',
    'ANGRY': '\u{1F621}',
    'SURPRISE': '\u{1F632}',
    'FIRE': '\u{1F525}',
  },
  'RECEIPT': {
    'READ': 'READ_RECEIPT',
  },
  'UA': {
    'LISTENER': {
      'JOIN': 'LISTENER_JOIN',
      'LEAVE': 'LISTENER_LEAVE',
      'MICREQUEST': 'LISTENER_REQUEST_MIC',
    },
    'SPEAKER': {
      'JOIN': 'SPEAKER_JOIN', //
      'LEAVE': 'SPEAKER_LEAVE', //
      'MIC_ON': 'SPEAKER_MIC_ON',
      'MIC_OFF': 'SPEAKER_MIC_OFF',
    }
  },
  'INTENT': {
    'ACCEPT': 'ACCEPT_INTENT',
    'REJECT': 'REJECT_INTENT',
    'JOIN': 'JOIN_GROUP',
    'LEAVE': 'LEAVE_GROUP',
  },
};

class AdditionalMetaType {
  static const CUSTOM = 0;
  static const PUSH_VIDEO = 1;

  static isValidAdditionalMetaType(int type) {
    return [CUSTOM, PUSH_VIDEO].contains(type);
  }
}
