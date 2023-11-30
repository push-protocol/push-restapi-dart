import '../../../push_restapi_dart.dart';

Future<List<GroupMemberPublicKey>> getGroupMembersPublicKeys({
  required String chatId,
  int page = 1,
  int limit = 20,
}) async {
  if (chatId.isEmpty) {
    throw Exception('chatId cannot be null or empty');
  }

  final result = await http.get(
      path:
          '/v1/chat/groups/$chatId/members/publicKeys?pageNumber=$page&pageSize=$limit');

  if (result == null || result is String) {
    throw Exception(result ?? 'Cannot get public keys for $chatId');
  }

  return (result['members'] as List)
      .map((e) => GroupMemberPublicKey.fromJson(e))
      .toList();
}
