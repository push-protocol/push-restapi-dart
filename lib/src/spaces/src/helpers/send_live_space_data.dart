import 'package:push_restapi_dart/push_restapi_dart.dart';

Future sendLiveSpaceData({
  required LiveSpaceData updatedLiveSpaceData,
  required META_ACTION action,
  required List<String> affectedAddresses,
  required String spaceId,
}) async {
  final content = '${action.toString()} $affectedAddresses';
  final metaMessage = MetaMessage(
    action: action,
    info: Info(
      affected: affectedAddresses,
      arbitrary: updatedLiveSpaceData.toJson(),
    ),
    content: content,
  );

  final options = ChatSendOptions(
      messageType: MessageType.META,
      message: metaMessage,
      receiverAddress: spaceId);
  return send(options);
}
