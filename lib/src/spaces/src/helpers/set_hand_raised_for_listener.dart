import 'package:push_restapi_dart/push_restapi_dart.dart';

SpaceData setHandRaisedForListener(
    {required bool handRaised,
    required String listenerAddress,
    required SpaceData spaceData}) {
  List<ListenerPeer> updatedListeners =
      spaceData.liveSpaceData.listeners.map((listener) {
    if (listener.address == listenerAddress) {
      listener.handRaised = handRaised;
    }
    return listener;
  }).toList();

  spaceData.liveSpaceData.listeners = updatedListeners;

  return spaceData;
}
