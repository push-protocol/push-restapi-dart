import '../../../push_restapi_dart.dart';

class SubscribeOptionsV2Type {
  Signer signer;
  String channelAddress;
  String userAddress;
  String? settings;
  String? verifyingContractAddress;
  ENV env;
  Function()? onSuccess;
  Function(Exception)? onError;

  SubscribeOptionsV2Type({
    required this.signer,
    required this.channelAddress,
    required this.userAddress,
    this.settings,
    this.verifyingContractAddress,
    required this.env,
    this.onSuccess,
    this.onError,
  });
}

Future<Map<String, dynamic>> subscribeV2(SubscribeOptionsV2Type options) async {
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

    final requestUrl = '/v1/channels/$channelAddress/subscribe';

    // get domain information
    final domainInformation = getDomainInformation(
      chainId,
      options.verifyingContractAddress ?? config.EPNS_COMMUNICATOR_CONTRACT,
    );

    // get type information
    final typeInformation = getTypeInformationV2();

    // get message
    final messageInformation = {
      'data': getSubscriptionMessageV2(
        channelCAIPDetails.address,
        userCAIPDetails.address,
        ChannelActionType.subscribe,
        userSetting: options.settings,
      ),
    };

    // sign a message using EIP712
    final signature = await options.signer.signTypedData(
      domain: domainInformation,
      types: typeInformation.data, // Ensure to cast correctly
      values: messageInformation,
      primaryType: 'Data',
    );

    final verificationProof = signature; // might change

    final body = {
      'verificationProof': 'eip712v2:$verificationProof',
      'message': messageInformation['data'],
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
