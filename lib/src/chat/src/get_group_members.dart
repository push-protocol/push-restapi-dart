import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<List<ChatMemberProfile>> getGroupMembers(
    {required String chatId, int page = 1, int limit = 20}) async {
  if (chatId.isEmpty) {
    throw Exception('chatId cannot be null or empty');
  }

  final result = await http.get(
    path: '/v1/chat/groups/$chatId/members?pageNumber=$page&pageSize=$limit',
  );

  if (result == null) {
    throw Exception(result);
  }

  if (result is String) {
    throw Exception(result);
  }

  return (result['members'] as List)
      .map((e) => ChatMemberProfile.fromJson(e))
      .toList();
}
