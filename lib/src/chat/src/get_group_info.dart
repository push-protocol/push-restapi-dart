import '../../../push_restapi_dart.dart';

Future<GroupInfoDTO?> getGroupInfo({required String chatId}) async {
  if (chatId.isEmpty) {
    throw Exception('chatId cannot be null or empty');
  }

  final result = await http.get(path: '/v2/chat/groups/$chatId');

  if (result == null) {
    return null;
  }

  if (result is String) {
    throw Exception(result);
  }

  return GroupInfoDTO.fromJson(result);
}
