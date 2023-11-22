import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<List<GroupMemberPublicKey>> getAllGroupMembersPublicKeys({
  required String chatId,
}) async {
  if (chatId.isEmpty) {
    throw Exception('chatId cannot be null or empty');
  }

  final count = await getGroupMemberCount(chatId: chatId);

  final limit = 5000;

  final totalPages = (count.overallCount / limit).ceil();

  final pagesResult = await Future.wait(
    List.generate(
      totalPages,
      (index) => getGroupMembersPublicKeys(
          chatId: chatId, page: index + 1, limit: limit),
    ),
  );

  var members = <GroupMemberPublicKey>[];
  for (var element in pagesResult) {
    members.addAll(element);
  }

  return members;
}
