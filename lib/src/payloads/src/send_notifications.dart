import 'package:push_restapi_dart/push_restapi_dart.dart';
import 'helpers.dart';

void validateOptions(SendNotificationInputOptions options) {
  if (!isValidETHAddress(options.channel)) {
    throw '[Push SDK] - Error - sendNotification() - "channel" is invalid!';
  }
  if (options.senderType == 0 && options.signer == null) {
    throw '[Push SDK] - Error - sendNotification() - "signer" is mandatory for this signerType!';
  }
  if (options.senderType == 1 && options.pgpPrivateKey == null) {
    throw '[Push SDK] - Error - sendNotification() - "pgpPrivateKey" is mandatory for this signerType!';
  }

  if (options.identityType == IDENTITY_TYPE.DIRECT_PAYLOAD ||
      options.identityType == IDENTITY_TYPE.MINIMAL) {
    if (options.notification == null) {
      throw '[Push SDK] - Error - sendNotification() - "notification" mandatory for Identity Type: Direct Payload, Minimal!';
    }
    if (options.payload == null) {
      throw '[Push SDK] - Error - sendNotification() - "payload" mandatory for Identity Type: Direct Payload, Minimal!';
    }
  }
}

Future<dynamic> sendNotification(SendNotificationInputOptions options) async {
  try {
    // validation Inputs
    validateOptions(options);

    // convert sender ( channel ) to CAIP
    final String channelAddress =
        await getCAIPAddress(address: options.channel);

    // parse CAIP Address
    final CAIPDetailsType? channelCAIPDetails = getCAIPDetails(channelAddress);
    if (channelCAIPDetails == null) throw Exception('Invalid Channel CAIP!');
    final int chainId = int.parse(channelCAIPDetails.networkId);

    // generates random uuid
    final String uuid = getUUID();

    final String communicatorContract = '';
    //getPushCommunicatorContractAddress(chainId);

    // parse notifcation receipients
    final recipients = await getRecipients(
        notificationType: options.type,
        channel: channelAddress,
        recipients: options.recipients,
        secretType: options.payload?.sectype);

    // parse and build notification payload
    final notificationPayload = getPayloadForAPIInput(options, recipients);

    // build verificationProof
    final String verificationProof = await getVerificationProof(
        senderType: options.senderType as int,
        signer: options.signer,
        chainId: chainId,
        notificationType: options.type,
        identityType: options.identityType,
        verifyingContract: communicatorContract,
        payload: notificationPayload,
        uuid: uuid,
        chatId: options.chatId,
        pgpPrivateKey: options.pgpPrivateKey,
        pgpPublicKey: options.pgpPublicKey);

    // build identity string
    final String identity = getPayloadIdentity(
        identityType: options.identityType,
        payload: notificationPayload,
        notificationType: options.type,
        graph: options.graph,
        ipfsHash: options.ipfsHash);

    // build notification source
    final String source =
        getSource(chainId, options.identityType, options.senderType as int);

    // build the post body
    final apiPayload = {
      'verificationProof': verificationProof,
      'identity': identity,
      'sender':
          options.senderType == 1 && !isValidCAIP10NFTAddress(channelAddress)
              ? '${channelCAIPDetails.blockchain}:${channelCAIPDetails.address}'
              : channelAddress,
      'source': source,
      /** note this recipient key has a different expectation from the BE API, see the function for more */
      'recipient': await getRecipientFieldForAPIPayload(
          notificationType: options.type,
          recipients: recipients,
          channel: channelAddress)
    };
    return await http.post(
      path: '/v1/payloads/',
      data: apiPayload,
    );
  } catch (err) {
    print('[Push SDK] - Error - sendNotification() - $err');
    rethrow;
  }
}
