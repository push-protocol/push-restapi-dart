import 'package:push_restapi_dart/push_restapi_dart.dart';

int getIncomingIndexFromAddress(List<PeerData> incomingPeers, String address) {
  return incomingPeers.indexWhere((incomingPeer) => incomingPeer.address == address);
}
