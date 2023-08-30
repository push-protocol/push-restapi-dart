// ignore_for_file: constant_identifier_names

import 'package:push_restapi_dart/push_restapi_dart.dart';

Future sendLiveSpaceData({
  liveSpaceData,
  int action = MetaAction.CREATE_GROUP,
  required String spaceId,
  String? pgpPrivateKey,
  Signer? signer,
  env,
}) async {
  assert(MetaAction.isValidMeatAction(action));

  // TODO: Add livespace data under messageObj.info.arbitary
  final options = ChatSendOptions(
      messageContent: 'PUSH SPACE META MESSAGE',
      messageType: MessageType.META,
      receiverAddress: spaceId,
      pgpPrivateKey: pgpPrivateKey,
      accountAddress: signer?.getAddress());
  return send(options);
}

class MetaAction {
  static const int CREATE_GROUP = 1;
  static const int ADD_MEMBER = 2;
  static const int REMOVE_MEMBER = 3;
  static const int PROMOTE_TO_ADMIN = 4;
  static const int DEMOTE_FROM_ADMIN = 5;
  static const int CHANGE_IMAGE_OR_DESC = 6;
  static const int CHANGE_META = 7;
  static const int CREATE_SPACE = 8;
  static const int ADD_LISTENER = 9;
  static const int REMOVE_LISTENER = 10;
  static const int PROMOTE_TO_SPEAKER = 11;
  static const int DEMOTE_FROM_SPEAKER = 12;
  static const int PROMOTE_TO_COHOST = 13;
  static const int DEMOTE_FROM_COHOST = 14;
  static const int USER_INTERACTION = 15;

  static bool isValidMeatAction(int item) {
    return [
      CREATE_GROUP,
      ADD_MEMBER,
      REMOVE_MEMBER,
      PROMOTE_TO_ADMIN,
      DEMOTE_FROM_ADMIN,
      CHANGE_IMAGE_OR_DESC,
      CHANGE_META,
      CREATE_SPACE,
      ADD_LISTENER,
      REMOVE_LISTENER,
      PROMOTE_TO_SPEAKER,
      DEMOTE_FROM_SPEAKER,
      PROMOTE_TO_COHOST,
      DEMOTE_FROM_COHOST,
      USER_INTERACTION,
    ].contains(item);
  }
}
