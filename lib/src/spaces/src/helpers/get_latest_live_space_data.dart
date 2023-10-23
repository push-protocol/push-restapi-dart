import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<LiveSpaceData> getLatestLiveSpaceData({
  String? accountAddress,
  String? pgpPrivateKey,
  required String spaceId,
}) async {
  final threadhash = await conversationHash(
    conversationId: spaceId,
    accountAddress: accountAddress,
  );

  LiveSpaceData liveSpaceData = initLiveSpaceData;

  if (threadhash != null) {
    final List<Message> messages = await history(
            threadhash: threadhash,
            toDecrypt: true,
            accountAddress: accountAddress,
            pgpPrivateKey: pgpPrivateKey) ??
        [];

    Message? latestMetaMessage;
    for (final message in messages) {
      if ((message.messageType == MessageType.META ||
              message.messageType == MessageType.USER_ACTIVITY) &&
          message.messageObj != null) {
        latestMetaMessage = message;
        break;
      }
    }

    if (latestMetaMessage != null) {
      liveSpaceData = LiveSpaceData.fromJson(
          MetaMessage.fromJson(latestMetaMessage.messageObj).info!.arbitrary);
    }
  }

  return liveSpaceData;
}
