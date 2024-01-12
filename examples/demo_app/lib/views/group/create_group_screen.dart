import 'package:flutter/cupertino.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

import '../../__lib.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController memberController = TextEditingController();
  TextEditingController adminController = TextEditingController();

  List<String> admins = [];
  List<String> members = [];

  bool isPublic = true;
  bool isLoading = false;
  updateLoading(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  PushAPI get pushUser => ref.read(accountProvider).pushUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text('Admin'),
                  Wrap(
                    children: List.generate(
                      admins.length,
                      (index) => Chip(label: Text(admins[index])),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Listeners'),
                  Wrap(
                    children: List.generate(
                      members.length,
                      (index) => Chip(label: Text(members[index])),
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(
                    color: Colors.black,
                  ),
                  SizedBox(height: 16),
                  InputField(
                    controller: nameController,
                    label: 'Group Name',
                  ),
                  SizedBox(height: 16),
                  InputField(
                    controller: descriptionController,
                    label: 'Group Description',
                  ),
                  SizedBox(height: 16),
                  InputField(
                    controller: adminController,
                    label: 'Add Admin Address',
                    suffixIcon: IconButton(
                      onPressed: onAddAdmin,
                      icon: Icon(Icons.add),
                    ),
                  ),
                  SizedBox(height: 16),
                  InputField(
                    controller: memberController,
                    label: 'Add Member Address',
                    suffixIcon: IconButton(
                      onPressed: onAddMember,
                      icon: Icon(Icons.add),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Is this a public group:'),
                      Spacer(),
                      CupertinoSwitch(
                        value: isPublic,
                        onChanged: (value) {
                          setState(() {
                            isPublic = value;
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            MaterialButton(
              color: pushColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              onPressed: onCreateGroup,
              textColor: Colors.white,
              child: Center(
                  child:
                      isLoading ? CircularProgressIndicator() : Text('Create')),
              padding: EdgeInsets.all(16),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  final groupImage =
      'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAvklEQVR4AcXBsW2FMBiF0Y8r3GQb6jeBxRauYRpo4yGQkMd4A7kg7Z/GUfSKe8703fKDkTATZsJsrr0RlZSJ9r4RLayMvLmJjnQS1d6IhJkwE2bT13U/DBzp5BN73xgRZsJMmM1HOolqb/yWiWpvjJSUiRZWopIykTATZsJs5g+1N6KSMiO1N/5DmAkzYTa9Lh6MhJkwE2ZzSZlo7xvRwson3txERzqJhJkwE2bT6+JhoKTMJ2pvjAgzYSbMfgDlXixqjH6gRgAAAABJRU5ErkJggg==';

  onCreateGroup() async {
    try {
      updateLoading(true);
      final result = await pushUser.chat.group.create(
        name: nameController.text.trim(),
        options: GroupCreationOptions(
          description: descriptionController.text.trim(),
          members: members,
          admins: admins,
          private: !isPublic,
          image: groupImage,
        ),
      );

      if (result == null) {
        showMyDialog(
            context: context, title: 'Error', message: 'Group not created');
      } else {
        ref.read(conversationsProvider).loadChats();
        showMyDialog(
          context: context,
          title: 'Success',
          message: 'Group created successfully',
          onClose: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      }

      updateLoading(false);
    } catch (e) {
      showMyDialog(
          context: context, title: 'Error', message: 'Group not created\n$e');
      updateLoading(false);
    }
  }

  onAddMember() {
    final address = memberController.text.trim();
    members.add(address);
    memberController.clear();
    setState(() {});
  }

  onAddAdmin() {
    final address = adminController.text.trim();
    admins.add(address);
    adminController.clear();
    setState(() {});
  }
}
