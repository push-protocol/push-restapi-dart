// ignore_for_file: constant_identifier_names

import '../../push_restapi_dart.dart';

class PushAPIInitializeProps {
  void Function(ProgressHookType)? progressHook;
  String? account;
  String? version;
  Map<String, Map<String, String>>? versionMeta;
  bool autoUpgrade;
  String? origin;

  PushAPIInitializeProps({
    this.progressHook,
    this.account,
    this.version = Constants.ENC_TYPE_V3,
    this.versionMeta,
    this.autoUpgrade = true,
    this.origin,
  });
}

// class ChatListType {
//   static const String CHATS = 'CHATS';
//   static const String REQUESTS = 'REQUESTS';

//   static bool isValidChatListType(String type) {
//     return [CHATS, REQUESTS].contains(type);
//   }
// }

enum ChatListType { CHATS, REQUESTS }
