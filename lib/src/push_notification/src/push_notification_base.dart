// ignore_for_file: constant_identifier_names
import '../../../push_restapi_dart.dart';

// ERROR CONSTANTS
const String ERROR_ACCOUNT_NEEDED = 'Account is required';
const String ERROR_SIGNER_NEEDED = 'Signer object is required';

const String BROADCAST_TYPE = '*';
const int LENGTH_UPPER_LIMIT = 125;
const int LENGTH_LOWER_LIMTI = 1;
const String SETTING_DELIMITER = '-';
const String SETTING_SEPARATOR = '+';
const int RANGE_TYPE = 3;
const int SLIDER_TYPE = 2;
const int BOOLEAN_TYPE = 1;
const String DEFAULT_ENABLE_VALUE = '1';
const String DEFAULT_TICKER_VALUE = '1';

class PushNotificationBaseClass {
  final Signer? signer;
  final String? account;
  final bool guestMode;
  final dynamic coreContract;
  final ENV env;

  PushNotificationBaseClass({
    required this.signer,
    required this.account,
    required this.guestMode,
    required this.coreContract,
    this.env = ENV.prod,
  });

  bool checkUserAddressExists([String? user]) {
    if (user == null && account == null && !guestMode) {
      throw Exception(ERROR_ACCOUNT_NEEDED);
    }
    return true;
  }

  bool checkSignerObjectExists() {
    if (signer == null) {
      throw Exception(PushAPI.ensureSignerMessage());
    }
    return true;
  }

  Map<String, dynamic> getNotificationType(
      List<String> recipient, String channel) {
    if (recipient.length == 1) {
      if (recipient[0] == BROADCAST_TYPE) {
        return {'recipient': channel, 'type': NOTIFICATION_TYPE.BROADCAST};
      } else {
        return {'recipient': recipient[0], 'type': NOTIFICATION_TYPE.TARGETTED};
      }
    }
    return {'recipient': recipient, 'type': NOTIFICATION_TYPE.SUBSET};
  }

  Future<num?> getChainId() async {
    return signer?.getChainId();
  }

  Future<String?> uploadToIPFSViaPushNode(dynamic data) async {
    try {
      final result = await http.post(
        path: '/v1/ipfs/upload',
        data: data,
        baseUrl: Api.getAPIBaseUrls(env),
      );
      return result['cid'];
    } catch (e) {
      throw Exception('Something went wrong while uploading data to IPFS');
    }
  }

  int getTimeBound([int? timeStamp]) {
    // for now returns 0 for non-time bound. Later it can be modified to handle time bound channels
    return 0;
  }

  Map<String, String> getMinimalSetting(
      List<NotificationSetting> configuration) {
    String notificationSetting = '';
    String notificationSettingDescription = '';

    for (int i = 0; i < configuration.length; i++) {
      NotificationSetting ele = configuration[i];

      if (ele.type == BOOLEAN_TYPE) {
        notificationSetting +=
            '$SETTING_SEPARATOR$BOOLEAN_TYPE$SETTING_DELIMITER${ele.defaultVal}';
      } else if (ele.type == SLIDER_TYPE) {
        if (ele.data != null) {
          final enabled = ele.data != null && ele.data?['enabled'] != null
              ? int.parse(ele.data!['enabled'].toString()).toString()
              : DEFAULT_ENABLE_VALUE;
          final ticker = ele.data?['ticker'] ?? DEFAULT_TICKER_VALUE;

          notificationSetting +=
              '$SETTING_SEPARATOR$SLIDER_TYPE$SETTING_DELIMITER$enabled$SETTING_DELIMITER'
              '${ele.defaultVal}$SETTING_DELIMITER${ele.data?['lower']}'
              '$SETTING_DELIMITER${ele.data?['upper']}$SETTING_DELIMITER$ticker';
        }
      } else if (ele.type == RANGE_TYPE) {
        if (ele.defaultVal != null &&
            ele.defaultVal is Map &&
            ele.data != null) {
          final enabled = ele.data != null && ele.data?['enabled'] != null
              ? int.parse(ele.data!['enabled'].toString()).toString()
              : DEFAULT_ENABLE_VALUE;
          final ticker = ele.data?['ticker'] ?? DEFAULT_TICKER_VALUE;

          notificationSetting +=
              '$SETTING_SEPARATOR$RANGE_TYPE$SETTING_DELIMITER$enabled'
              '$SETTING_DELIMITER${ele.defaultVal['lower']}$SETTING_DELIMITER'
              '${ele.defaultVal['upper']}$SETTING_DELIMITER${ele.data?['lower']}'
              '$SETTING_DELIMITER${ele.data?['upper']}$SETTING_DELIMITER$ticker';
        }
      }

      notificationSettingDescription += '$SETTING_SEPARATOR${ele.description}';
    }

    return {
      'setting': notificationSetting.replaceFirst(RegExp(r'^\+'), ''),
      'description':
          notificationSettingDescription.replaceFirst(RegExp(r'^\+'), ''),
    };
  }

  String? getMinimalUserSetting(List<UserSetting>? setting) {
    if (setting == null) {
      return null;
    }
    String userSetting = '';
    int numberOfSettings = 0;
    for (int i = 0; i < setting.length; i++) {
      final ele = setting[i];
      final enabled = ele.enabled ? '1' : '0';
      if (ele.enabled) numberOfSettings++;

      if (ele.value != null) {
        // Slider type or Range type
        if (ele.value is num) {
          userSetting +=
              '$SLIDER_TYPE$SETTING_DELIMITER$enabled$SETTING_DELIMITER${ele.value}';
        } else {
          userSetting +=
              '$RANGE_TYPE$SETTING_DELIMITER$enabled$SETTING_DELIMITER${ele.value?['lower']}$SETTING_DELIMITER${ele.value?['upper']}';
        }
      } else {
        // Boolean type
        userSetting += '$BOOLEAN_TYPE$SETTING_DELIMITER$enabled';
      }
      if (i != setting.length - 1) {
        userSetting += SETTING_SEPARATOR;
      }
    }
    return '$numberOfSettings$SETTING_SEPARATOR$userSetting';
  }

  Future<dynamic> getChannelOrAliasInfo(String address) async {
    address = validateCAIP(address)
        ? address
        : getFallbackETHCAIPAddress(address: address, env: env);
    final channelInfo = await getChannel(channel: address);
    if (channelInfo != null) {
      return channelInfo;
    }

    final aliasInfo = await http.get(
      path: '/v1/alias/$address/channel',
      baseUrl: Api.getAPIBaseUrls(env),
    );

    final aliasInfoFromChannel = await getChannel(
      channel: aliasInfo['channel'],
    );
    return aliasInfoFromChannel;
  }

  String getAddressFromCaip(String caipAddress) {
    List<String> parts = caipAddress.split(':');
    return parts[parts.length - 1];
  }
}
