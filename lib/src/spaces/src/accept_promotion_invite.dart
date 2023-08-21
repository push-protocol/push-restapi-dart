import 'package:push_restapi_dart/push_restapi_dart.dart';

class AcceptPromotionInviteType {
  dynamic signalData;
  String invitorAddress;
  String spaceId;

  AcceptPromotionInviteType({
    required this.signalData,
    required this.invitorAddress,
    required this.spaceId,
  });
}

acceptPromotionInvite({
  required SpaceDTO space,
  required AcceptPromotionInviteType options,
}) {}
