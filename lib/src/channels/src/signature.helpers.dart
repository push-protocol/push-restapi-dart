import 'package:push_restapi_dart/push_restapi_dart.dart';

// class DomainInformation extends DataDomain {
//   final String name;

//   final int chainId;

//   final String verifyingContract;

//   DomainInformation(this.name, this.chainId, this.verifyingContract)
//       : super(
//           name: name,
//           chainId: chainId,
//           verifyingContract: verifyingContract,
//         );
// }

enum ChannelActionType { unsubscribe, subscribe }

class SubscriptionMessage {
  final String channel;
  final String action;
  final String subscriber;
  final String? unsubscriber;

  SubscriptionMessage(this.channel, this.action, this.subscriber,
      {this.unsubscriber});
  Map<String, dynamic> toJson() {
    return {
      "channel": channel,
      "action": action,
      action: unsubscriber ?? subscriber,
    };
  }
}

class SubscriptionMessageV2 {
  final String channel;
  final String action;
  final String subscriber;
  final String? unsubscriber;
  final String? userSetting;

  SubscriptionMessageV2(this.channel, this.action, this.subscriber,
      {this.unsubscriber, this.userSetting});

  Map<String, dynamic> toJson() {
    return {
      "channel": channel,
      "action": action,
      action: unsubscriber ?? subscriber,
    };
  }
}

class TypeInformationMap {
  final Map<String, List<DataField>> data;

  TypeInformationMap(this.data);
}

DataDomain getDomainInformation(int chainId, String verifyingContract) {
  return DataDomain(
      name: 'EPNS COMM V1',
      chainId: chainId,
      verifyingContract: verifyingContract);
}

Map<String, dynamic> getSubscriptionMessage(
    String channel, String userAddress, ChannelActionType action) {
  final actionTypeKey =
      action == ChannelActionType.unsubscribe ? 'unsubscriber' : 'subscriber';
  return {
    'channel': channel,
    actionTypeKey: userAddress,
    'action':
        action == ChannelActionType.subscribe ? 'Subscribe' : 'Unsubscribe',
  };
}

SubscriptionMessageV2 getSubscriptionMessageV2(
    String channel, String userAddress, ChannelActionType action,
    {String? userSetting}) {
  return SubscriptionMessageV2(channel, action.toString(), userAddress,
      unsubscriber:
          action == ChannelActionType.unsubscribe ? userAddress : null,
      userSetting: userSetting);
}

TypeInformationMap getTypeInformation(ChannelActionType action) {
  if (action == ChannelActionType.subscribe) {
    return TypeInformationMap({
      'Subscribe': [
        DataField('channel', 'address'),
        DataField('subscriber', 'address'),
        DataField('action', 'string'),
      ],
    });
  }

  return TypeInformationMap({
    'Unsubscribe': [
      DataField('channel', 'address'),
      DataField('unsubscriber', 'address'),
      DataField('action', 'string'),
    ],
  });
}

TypeInformationMap getTypeInformationV2() {
  return TypeInformationMap({
    'Data': [DataField('data', 'string')],
  });
}
