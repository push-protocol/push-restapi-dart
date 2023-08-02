import '../../../push_restapi_dart.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart' as push;

Future<SpaceDTO?> create({
  String? account,
  Signer? signer,
  required String spaceName,
  required String spaceDescription,
  required String spaceImage,
  required List<String> listeners,
  required List<String> speakers,
  required bool isPublic,
  String? contractAddressNFT,
  int? numberOfNFTs,
  String? contractAddressERC20,
  int? numberOfERC20,
  String? pgpPrivateKey,
  String? meta,
  required DateTime scheduleAt,
  DateTime? scheduleEnd,
}) async {
  try {
    final result = await push.createGroup(
      signer: signer,
      account: account,
      groupName: spaceName,
      groupDescription: spaceDescription,
      groupImage: spaceImage,
      members: listeners,
      admins: speakers,
      isPublic: isPublic,
      contractAddressNFT: contractAddressNFT,
      numberOfNFTs: numberOfNFTs,
      contractAddressERC20: contractAddressERC20,
      numberOfERC20: numberOfERC20,
      pgpPrivateKey: pgpPrivateKey,
      meta: meta,
      groupType: 'spaces',
      scheduleAt: scheduleAt,
      scheduleEnd: scheduleEnd,
    );

    return groupDtoToSpaceDto(result!);
  } catch (e) {
    log("[Push SDK] - API  - Error - API createSpace -: $e ");
    rethrow;
  }
}
