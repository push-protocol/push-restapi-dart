import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<ChatMemberCounts> getGroupMemberCount({required String chatId}) async {
  if (chatId.isEmpty) {
    throw Exception('chatId cannot be null or empty');
  }

  final result = await http.get(path: '/v1/chat/groups/$chatId/members/count');

  if (result == null || result is String) {
    throw Exception(
        result ?? 'Failed to retrieve group member count. ChatId: $chatId');
  }

  return ChatMemberCounts.fromJson(result['totalMembersCount']);
}
