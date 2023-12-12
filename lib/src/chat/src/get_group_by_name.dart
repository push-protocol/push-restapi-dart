import 'package:push_restapi_dart/push_restapi_dart.dart';

Future<GroupDTO?> getGroupByName({required String groupName}) async {
  log("=============================================");
  log("NOTICE: The method 'getGroupByName' will be deprecated on January 1st, 2024. Please update your code to remove this.");
  log("=============================================");

  if (groupName.isEmpty) {
    throw Exception('Group Name cannot be null or empty');
  }

  final result = await http.get(path: '/v1/chat/groups?groupName=$groupName');

  if (result == null) {
    return null;
  }
  return GroupDTO.fromJson(result);
}
