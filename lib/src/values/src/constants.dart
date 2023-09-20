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
  static const IMAGE = 'Image';
  static const FILE = 'File';
  static const MEDIA_EMBED = 'MediaEmbed';
  static const META = 'Meta';
  static const REACTION = 'Reaction';

  /// @deprecated - Use MediaEmbed Instead
  static const GIF = 'GIF';

  static isValidMessageType(String type) {
    return [TEXT, IMAGE, FILE, MEDIA_EMBED, META, REACTION].contains(type);
  }
}

enum META_ACTION {
  /// DEFAULT GROUP ACTIONS
  CREATE_GROUP,
  ADD_MEMBER,
  REMOVE_MEMBER,
  PROMOTE_TO_ADMIN,
  DEMOTE_FROM_ADMIN,

  /// SHARED ACTIONS
  CHANGE_IMAGE_OR_DESC,
  CHANGE_META,

  /// SPACES ACTIONS
  CREATE_SPACE,
  ADD_LISTENER,
  REMOVE_LISTENER,
  PROMOTE_TO_SPEAKER,
  DEMOTE_FROM_SPEAKER,
  PROMOTE_TO_COHOST,
  DEMOTE_FROM_COHOST,
  USER_INTERACTION, // For MIC_ON | MIC_OFF | RAISE_HAND | EMOJI REACTION | or any other user activity
}

META_ACTION getMetaActionValue(int index) {
  switch (index) {
    case 0:
      return META_ACTION.CREATE_GROUP;
    case 1:
      return META_ACTION.ADD_MEMBER;
    case 2:
      return META_ACTION.REMOVE_MEMBER;
    case 3:
      return META_ACTION.PROMOTE_TO_ADMIN;
    case 4:
      return META_ACTION.DEMOTE_FROM_ADMIN;
    case 5:
      return META_ACTION.CHANGE_IMAGE_OR_DESC;
    case 6:
      return META_ACTION.CHANGE_META;
    case 7:
      return META_ACTION.CREATE_SPACE;
    case 8:
      return META_ACTION.ADD_LISTENER;
    case 9:
      return META_ACTION.REMOVE_LISTENER;
    case 10:
      return META_ACTION.PROMOTE_TO_SPEAKER;
    case 11:
      return META_ACTION.DEMOTE_FROM_SPEAKER;
    case 12:
      return META_ACTION.PROMOTE_TO_COHOST;
    case 13:
      return META_ACTION.DEMOTE_FROM_COHOST;
    case 14:
      return META_ACTION.USER_INTERACTION;
    default:
      throw ArgumentError('Invalid index: $index');
  }
}

enum REACTION_TYPE {
  THUMBS_UP,
  THUMBS_DOWN,
  HEART,
  CLAP,
  LAUGHING_FACE,
  SAD_FACE,
  ANGRY_FACE,
  SURPRISED_FACE,
  CLAPPING_HANDS,
  FIRE,
}

// Create a mapping object that associates reaction types with their Unicode escape sequences
const Map<REACTION_TYPE, String> REACTION_SYMBOL = {
  REACTION_TYPE.THUMBS_UP: '\u{1F44D}',
  REACTION_TYPE.THUMBS_DOWN: '\u{1F44E}',
  REACTION_TYPE.HEART: '\u{2764}\u{FE0F}',
  REACTION_TYPE.CLAP: '\u{1F44F}',
  REACTION_TYPE.LAUGHING_FACE: '\u{1F602}',
  REACTION_TYPE.SAD_FACE: '\u{1F622}',
  REACTION_TYPE.ANGRY_FACE: '\u{1F621}',
  REACTION_TYPE.SURPRISED_FACE: '\u{1F632}',
  REACTION_TYPE.CLAPPING_HANDS: '\u{1F44F}\u{1F44F}',
  REACTION_TYPE.FIRE: '\u{1F525}',
};

class AdditionalMetaType {
  static const CUSTOM = 0;
  static const PUSH_VIDEO = 1;

  static isValidAdditionalMetaType(int type) {
    return [CUSTOM, PUSH_VIDEO].contains(type);
  }
}
