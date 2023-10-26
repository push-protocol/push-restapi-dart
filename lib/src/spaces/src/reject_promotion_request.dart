import '../../../push_restapi_dart.dart';

SpaceData rejectPromotionRequest_(
    {required SpaceData data, required String promoteeAddress}) {
  final localAddress = getCachedWallet()!.address!;
  if (localAddress != pCAIP10ToWallet(data.spaceCreator)) {
    throw Exception("Only host is allowed to reject a promotion request");
  }

  data = setHandRaisedForListener(
      handRaised: false, listenerAddress: promoteeAddress, spaceData: data);

  return data;
}
