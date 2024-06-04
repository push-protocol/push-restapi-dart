import '../../../push_restapi_dart.dart';
import '../../channels/channels.dart' as push_channel;
import '../../channels/src/_get_subscribers.dart' as sub;

class Channel {
  Channel(
      {Signer? signer,
      required String account,
      String? decryptedPgpPvtKey,
      String? pgpPublicKey,
      required ENV env}) {
    _account = account;
    _env = env;

    delegate = Delegate(env: env, account: account);
    alias = Alias(env: env, signer: signer);
  }

  late final ENV _env;

  late final String? _account;

  late final Delegate delegate;
  late final Alias alias;

  /// @description - returns information about a channel
  /// @param {string} [channel] - channel address in caip, defaults to eth caip address
  /// @returns information about the channel if it exists
  Future<dynamic> info({String? channel, bool? raw}) async {
    channel ??= getFallbackETHCAIPAddress(address: _account!, env: _env);
    return getChannel(channel: channel);
  }

  /// @description - returns relevant information as per the query that was passed
  /// @param {string} query - search query
  /// @param {number} [options.page] -  page number. default is set to Constants.PAGINATION.INITIAL_PAGE
  /// @param {number} [options.limit] - number of feeds per page. default is set to Constants.PAGINATION.LIMIT
  /// @returns Array of results relevant to the serach query
  Future<dynamic> search(
      {required String query, int page = 1, int limit = 10}) async {
    return push_channel.search(
        query: query, env: _env, limit: limit, page: page);
  }

  Future<dynamic> subscribers({ChannelInfoOptions? options}) async {
    var channel = options?.channel ??
        (_account != null
            ? getFallbackETHCAIPAddress(env: _env, address: _account!)
            : null);

    if (options != null && options.page != null) {
      return push_channel.getSubscribers(GetChannelSubscribersOptionsType(
        channel: channel!,
        category: options.category,
        env: _env,
        limit: options.limit ?? 10,
        page: options.page ?? 1,
        raw: options.raw,
        setting: options.setting,
      ));
    } else {
      /// @dev - Fallback to deprecated method when page is not provided ( to ensure backward compatibility )
      /// @notice - This will be removed in V2 Publish
      return sub.getSubscribers(channel: channel!, env: _env);
    }
  }
}
