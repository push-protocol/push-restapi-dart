import '../../../push_restapi_dart.dart';

class UnSubscribeOptionsType {
  Signer signer;
  String channelAddress;
  String userAddress;
  String? verifyingContractAddress;
  ENV env;
  Function()? onSuccess;
  Function(Exception)? onError;

  UnSubscribeOptionsType({
    required this.signer,
    required this.channelAddress,
    required this.userAddress,
    this.verifyingContractAddress,
    required this.env,
    this.onSuccess,
    this.onError,
  });
}

Future<Map<String, dynamic>> unsubscribe(UnSubscribeOptionsType options) async {
  try {
    final channelAddress = await getCAIPAddress(
      address: options.channelAddress,
    );

    final channelCAIPDetails = getCAIPDetails(channelAddress);
    if (channelCAIPDetails == null) throw Exception('Invalid Channel CAIP!');

    final chainId = int.parse(channelCAIPDetails.networkId);

    final userAddress = await getCAIPAddress(address: options.userAddress);

    final userCAIPDetails = getCAIPDetails(userAddress);
    if (userCAIPDetails == null) throw Exception('Invalid User CAIP!');

    final config = getConfig(
        env: options.env,
        blockchain: channelCAIPDetails.blockchain,
        networkId: channelCAIPDetails.networkId);

    final requestUrl = '/v1/channels/$channelAddress/unsubscribe';

    // get domain information
    final domainInformation = getDomainInformation(
      chainId,
      options.verifyingContractAddress ?? config.EPNS_COMMUNICATOR_CONTRACT,
    );

    // get type information
    final typeInformation = getTypeInformation(ChannelActionType.unsubscribe);

    // get message
    final messageInformation = getSubscriptionMessage(
      channelCAIPDetails.address,
      userCAIPDetails.address,
      ChannelActionType.unsubscribe,
    );

    // sign a message using EIP712
    final signature = await options.signer.signTypedData(
      domain: domainInformation,
      types: typeInformation.data, // Ensure to cast correctly
      values: messageInformation,
      primaryType: 'Unsubscribe',
    );

    final verificationProof = signature; // might change

    final body = {
      'verificationProof': verificationProof,
      'message': {
        ...messageInformation,
        'channel': channelAddress,
        'subscriber': userAddress,
      },
    };

    await http.post(
      path: requestUrl,
      data: body,
      baseUrl: config.API_BASE_URL,
    );

    if (options.onSuccess != null) {
      options.onSuccess!();
    }

    return {
      'status': 'success',
      'message': 'successfully opted into channel',
    };
  } catch (err) {
    if (options.onError != null) {
      options.onError!(err as Exception);
    }

    return {
      'status': 'error',
      'message': err.toString(),
    };
  }
}
