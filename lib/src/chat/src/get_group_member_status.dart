import '../../../push_restapi_dart.dart';

Future<GroupMemberStatus> getGroupMemberStatus({
  required String chatId,
  required String did,
}) async {
  if (chatId.isEmpty) {
    throw Exception('chatId cannot be null or empty');
  }
  if (did.isEmpty) {
    throw Exception('did cannot be null or empty');
  }

  final user = await getUserDID(address: did);

  final result = await http.get(
    path: '/v1/chat/groups/$chatId/members/$user/status',
  );

  if (result == null || result is String) {
    throw Exception(result ?? 'Cannot get group satus');
  }

  return GroupMemberStatus.fromJson(result);
}
