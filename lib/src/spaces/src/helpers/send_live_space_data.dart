import 'package:push_restapi_dart/push_restapi_dart.dart';

Future sendLiveSpaceData({
  required LiveSpaceData liveSpaceData,
  required String spaceId,
  required int action
}) async {
  assert(isValidMetaAction(action));

  // TODO: Add livespace data under messageObj.info.arbitary
  final options = ChatSendOptions(
      messageContent: 'PUSH SPACE META MESSAGE',
      messageType: MessageType.META,
      receiverAddress: spaceId);
  return send(options);
}
