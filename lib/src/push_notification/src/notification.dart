import '../../../push_restapi_dart.dart';
import '../../user/user.dart' as push_user;
import '../../channels/channels.dart' as push_channel;

class NotificationAPI extends PushNotificationBaseClass {
  NotificationAPI({
    required super.signer,
    required super.account,
    required super.guestMode,
    super.env,
  });

  Future list({FeedType spam = FeedType.INBOX, FeedsOptions? options}) async {
    try {
      final channels = options?.channels ?? [];

      String? account;
      if (options?.account != null) {
        if (isValidPCaip(options!.account!)) {
          account = pCAIP10ToWallet(options.account!);
        } else {
          account = options.account;
        }
      } else if (this.account != null) {
        account = getFallbackETHCAIPAddress(env: env, address: this.account!);
      }

// guest mode and valid address check
      checkUserAddressExists(account!);
      final nonCaipAccount = getAddressFromCaip(account);

      final page = options?.page ?? Pagination.INITIAL_PAGE;
      final limit = options?.limit ?? Pagination.LIMIT;
      if (channels.isEmpty) {
        return push_user.getFeeds(
          address: nonCaipAccount,
          page: page,
          limit: limit,
          raw: options?.raw ?? false,
          spam: spam == FeedType.SPAM,
        );
      } else {
        final promises = await Future.wait(
          channels.map(
            (channel) => push_user.getFeedsPerChannel(
              options: FeedsPerChannelOptions(
                user: nonCaipAccount,
                page: page,
                limit: limit,
                spam: spam == FeedType.SPAM,
                channels: [channel],
                env: env,
              ),
            ),
          ),
        );
        var output = [];
        for (var i in promises) {
          output.add(i);
        }

        return output;
      }
    } catch (error) {
      log('Push SDK Error: API : notifcaiton::list : $error');
      rethrow;
    }
  }

  Future<dynamic> subscriptions({required SubscriptionOptions options}) async {
    String? account;
    if (options.account != null) {
      if (isValidPCaip(options.account!)) {
        account = pCAIP10ToWallet(options.account!);
      } else {
        account = options.account;
      }
    } else if (this.account != null) {
      account = getFallbackETHCAIPAddress(env: env, address: this.account!);
    }

    checkUserAddressExists(account);
    return push_user.getSubscriptions(
      address: account!,
      channel: options.channel,
    );
  }

  Future<dynamic> subscribe({
    required String channel,
    SubscribeUnsubscribeOptions? options,
  }) async {
    try {
      // Vaidatiions
      // validates if signer object is present
      checkSignerObjectExists();
      // validates if the user address exists
      checkUserAddressExists();
      // validates if channel exists
      if (channel.trim().isEmpty) {
        throw Exception('Channel is needed');
      }
      // convert normal partial caip to wallet
      if (isValidPCaip(channel)) {
        channel = pCAIP10ToWallet(channel);
      }
      // validates if caip is correct
      if (!validateCAIP(channel)) {
        channel = getFallbackETHCAIPAddress(address: channel);
      }

      // get channel caip
      final caipDetail = getCAIPDetails(channel);
      // based on the caip, construct the user caip
      final userAddressInCaip = getCAIPWithChainId(
          account!, int.parse(caipDetail?.networkId.toString() ?? ''));
      // convert the setting to minimal version
      final minimalSetting = getMinimalUserSetting(options?.settings);

  
      return push_channel.subscribeV2(SubscribeOptionsV2Type(
        signer: signer!,
        channelAddress: channel,
        userAddress: userAddressInCaip,
        env: env,
        settings: minimalSetting ?? '',
        onError: options?.onError,
        onSuccess: options?.onSuccess,
      ));
    } catch (e) {
      throw Exception('Push SDK Error: API : notifcaiton::subscribe : $e');
    }
  }

  Future<dynamic> unsubscribe({
    required String channel,
    SubscribeUnsubscribeOptions? options,
  }) async {
    try {
      // Vaidatiions
      // validates if signer object is present
      checkSignerObjectExists();
      // validates if the user address exists
      checkUserAddressExists();
      // validates if channel exists
      if (channel.trim().isEmpty) {
        throw Exception('Channel is needed');
      }
      // convert normal partial caip to wallet
      if (isValidPCaip(channel)) {
        channel = pCAIP10ToWallet(channel);
      }
      // validates if caip is correct
      if (!validateCAIP(channel)) {
        channel = getFallbackETHCAIPAddress(address: channel);
      }

      // get channel caip
      final caipDetail = getCAIPDetails(channel);
      // based on the caip, construct the user caip
      final userAddressInCaip = getCAIPWithChainId(
          account!, int.parse(caipDetail?.networkId.toString() ?? ''));

      return push_channel.unsubscribeV2(UnSubscribeOptionsV2Type(
        signer: signer!,
        channelAddress: channel,
        userAddress: userAddressInCaip,
        env: env,
        onError: options?.onError,
        onSuccess: options?.onSuccess,
      ));
    } catch (e) {
      throw Exception('Push SDK Error: API : notifcaiton::unsubscribe : $e');
    }
  }
}
