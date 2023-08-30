import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<LiveSpaceData> getLiveSpaceData({
  required String localAddress,
  required String spaceId,
  required String pgpPrivateKey,
}) async {
  final threadhash = await conversationHash(
    account: localAddress,
    conversationId: spaceId,
  );

  LiveSpaceData liveSpaceData = initLiveSpaceData;

  if (threadhash != null) {
    final messages = await history(
      threadhash: threadhash,
      accountAddress: localAddress,
      pgpPrivateKey: pgpPrivateKey,
      toDecrypt: true,
    ) ?? [];

    // TODO: Fix below code when meta message is added
    Message? latestMetaMessage;
    for (final message in messages) {
      if (message.messageType == MessageType.META &&
          message.messageObj is Map<String, dynamic> &&
          message.messageObj != null) {
        latestMetaMessage = message;
        break;
      }
    }

    if (latestMetaMessage != null &&
        latestMetaMessage.messageObj is Map<String, dynamic> &&
        latestMetaMessage.messageObj != null) {
      liveSpaceData = (latestMetaMessage.messageObj as MetaMessage)
          ?.info
          ?.arbitrary as LiveSpaceData;
    }
  }

  return liveSpaceData;
}
