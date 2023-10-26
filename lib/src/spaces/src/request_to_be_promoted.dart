import '../../../push_restapi_dart.dart';

SpaceData requestToBePromoted_({
  required SpaceData data,
}) {
  final localAddress = getCachedWallet()!.address!;

    // check is the caller is an active listener & modify listener data accordingly
    bool isActiveListener = false;
    for (int i = 0; i < data.liveSpaceData.listeners.length; i++) {
      ListenerPeer listener = data.liveSpaceData.listeners[i];
      if (listener.address == pCAIP10ToWallet(localAddress)) {
        if (listener.handRaised == true) {
          // listener's hand is already raised
          return data;
        }

        listener.handRaised = true;
        isActiveListener = true;
      }
    }

    if (!isActiveListener) {
      throw Exception("Local user is not a listener");
    }

    // send a user activity message
    sendLiveSpaceData(
        messageType: MessageType.USER_ACTIVITY,
        updatedLiveSpaceData: data.liveSpaceData,
        content: CHAT.UA_LISTENER_REQUEST_MIC,
        affectedAddresses: [localAddress],
        spaceId: data.spaceId);

    return data;
}
