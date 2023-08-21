import '../../../push_restapi_dart.dart';

class AcceptPromotionRequestType {
  final dynamic signalData;
  final String promoteeAddress;
  final SPACE_REQUEST_TYPE role;
  final String spaceId;

  AcceptPromotionRequestType({
    required this.signalData,
    required this.promoteeAddress,
    required this.role,
    required this.spaceId,
  });
}

acceptPromotionRequest({
  required SpaceDTO space,
  required AcceptPromotionRequestType options,
}) {}
