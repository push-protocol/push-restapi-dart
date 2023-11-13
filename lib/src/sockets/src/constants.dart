// ignore_for_file: non_constant_identifier_names

// class ENV {
//   static final PROD = 'prod';
//   static final STAGING = 'staging';
//   static final DEV = 'dev';

//   /// **This is for local development only**
//   static final LOCAL = 'local';
// }

class EVENTS {
  // Websocket
  static final CONNECT = 'connect';
  static final DISCONNECT = 'disconnect';

  // Notification
  static final USER_FEEDS = 'userFeeds';
  static final USER_SPAM_FEEDS = 'userSpamFeeds';

  // Chat
  static final CHAT_RECEIVED_MESSAGE = 'CHATS';
  static final CHAT_GROUPS = 'CHAT_GROUPS';

  //Spaces
  static final SPACES_MESSAGES = 'SPACES_MESSAGES';
  static final SPACES = 'SPACES';
}

class SOCKETTYPES {
  static final NOTIFICATION = 'notification';
  static final CHAT = 'chat';
}
