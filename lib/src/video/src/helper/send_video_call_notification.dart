import 'dart:convert';
import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<void> sendVideoCallNotification(
  UserInfoType userInfo,
  VideoCallInfoType videoCallInfo,
) async {
  try {
    final VideoDataType videoData = VideoDataType(
      recipientAddress: videoCallInfo.recipientAddress,
      senderAddress: videoCallInfo.senderAddress,
      chatId: videoCallInfo.chatId,
      signalData: videoCallInfo.signalData,
      status: videoCallInfo.status,
      callDetails: videoCallInfo.callDetails,
    );

    print('sendVideoCallNotification videoData: $videoData');

    final senderAddressInCaip =
        getCAIPWithChainId(videoCallInfo.senderAddress, userInfo.chainId);
    final recipientAddressInCaip =
        getCAIPWithChainId(videoCallInfo.recipientAddress, userInfo.chainId);

    final notificationText = 'Video Call from ${videoCallInfo.senderAddress}';
    final notificationType = NOTIFICATION_TYPE.TARGETTED;

    await sendNotification(SendNotificationInputOptions(
        senderType: 1,
        signer: userInfo.signer,
        pgpPrivateKey: userInfo.pgpPrivateKey,
        chatId: videoCallInfo.chatId,
        type: notificationType,
        identityType: IDENTITY_TYPE.DIRECT_PAYLOAD,
        notification: NotificationOptions(
          title: notificationText,
          body: notificationText,
        ),
        payload: PayloadOptions(
          title: 'VideoCall',
          body: 'VideoCall',
          cta: '',
          img: '',
          additionalMeta: AdditionalMeta(
            type: '${videoCallInfo.callType}+1',
            data: jsonEncode(videoData),
          ),
        ),
        recipients: recipientAddressInCaip,
        channel: senderAddressInCaip));
  } catch (err) {
    print('Error occurred while sending notification for video call: $err');
  }
}
