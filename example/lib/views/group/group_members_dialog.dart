import 'package:example/views/account_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

import '../../__lib.dart';

class GroupMembersDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext contex, ref) {
    final room = ref.watch(chatRoomProvider);

    final admins = room.admins;

    final isUserAdmin = room.isUserAdmin;

    final members = room.members;
    final pending = room.pendingMembers;
    final chatId = room.currentChatId;

    return Container(
      height: 640,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.purple.withOpacity(.5),
              ]),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
          color: Colors.white),
      child: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(tabs: [
              Tab(text: 'Admin'),
              Tab(text: 'Members'),
              Tab(text: 'Pending'),
            ]),
            Expanded(
                child: TabBarView(children: [
              GroupAdminsView(
                  admins: admins, isUserAdmin: isUserAdmin, chatId: chatId),
              GroupMembersView(
                  members: members, isUserAdmin: isUserAdmin, chatId: chatId),
              GroupPendingMembersView(
                  pendingMembers: pending,
                  isUserAdmin: isUserAdmin,
                  chatId: chatId),
            ]))
          ],
        ),
      ),
    );
  }
}

class GroupAdminsView extends StatelessWidget {
  const GroupAdminsView({
    super.key,
    required this.admins,
    required this.isUserAdmin,
    required this.chatId,
  });

  final List<MemberDTO> admins;
  final bool isUserAdmin;
  final String? chatId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: admins.isEmpty
              ? Center(
                  child: Text('No Admin in group'),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  itemCount: admins.length,
                  itemBuilder: (context, index) {
                    final item = admins[index];
                    return ListTile(
                        leading: ProfileImage(imageUrl: item.image),
                        title: Text('${item.wallet}'),
                        trailing: MemberActionWidget(
                          item: item,
                          isRemoveAdmin: true,
                          isUserAdmin: isUserAdmin,
                          chatId: chatId,
                        ));
                  },
                ),
        ),
        if (isUserAdmin)
          MaterialButton(
            color: Colors.purple,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onPressed: () {
        
              pushScreen(AddGroupMember(
                chatId: chatId,
                isAdmin: true,
              ));
            },
            textColor: Colors.white,
            child: Center(child: Text('Add new admin')),
            padding: EdgeInsets.all(16),
          ),
        SizedBox(height: 24),
      ],
    );
  }
}

class GroupMembersView extends StatelessWidget {
  const GroupMembersView({
    super.key,
    required this.members,
    required this.isUserAdmin,
    required this.chatId,
  });

  final List<MemberDTO> members;
  final bool isUserAdmin;
  final String? chatId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: members.isEmpty
                ? Center(
                    child: Text('No members in group'),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final item = members[index];
                      return ListTile(
                        leading: ProfileImage(imageUrl: item.image),
                        title: Text('${item.wallet}'),
                        trailing: MemberActionWidget(
                          item: item,
                          isRemoveAdmin: false,
                          isUserAdmin: isUserAdmin,
                          chatId: chatId,
                        ),
                      );
                    },
                  ),
          ),
          if (isUserAdmin)
            MaterialButton(
              color: Colors.purple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              onPressed: () {
                pushScreen(AddGroupMember(
                  chatId: chatId,
                  isAdmin: false,
                ));
              },
              textColor: Colors.white,
              child: Center(child: Text('Add new member')),
              padding: EdgeInsets.all(16),
            ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class MemberActionWidget extends ConsumerStatefulWidget {
  const MemberActionWidget({
    super.key,
    required this.item,
    required this.isUserAdmin,
    required this.isRemoveAdmin,
    required this.chatId,
  });

  final MemberDTO item;
  final bool isUserAdmin;
  final bool isRemoveAdmin;
  final String? chatId;

  @override
  ConsumerState<MemberActionWidget> createState() => _MemberActionWidgetState();
}

class _MemberActionWidgetState extends ConsumerState<MemberActionWidget> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(accountProvider).pushWallet?.address;
    if (widget.item.wallet == walletToPCAIP10(currentUser!)) {
      return Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: Colors.deepPurple, borderRadius: BorderRadius.circular(8)),
        child: Text(
          'You',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
      );
    }
    if (widget.isUserAdmin) {
      return TextButton(
        onPressed: () {
          if (widget.isRemoveAdmin) {
            _removeAdmin();
          } else {
            _removeMember();
          }
        },
        child: Text(
          'Remove',
          style: TextStyle(color: Colors.red, fontSize: 14),
        ),
      );
    }
    return SizedBox.shrink();
  }

  _removeMember() {
    showLoadingDialog();
    removeMembers(
      chatId: widget.chatId!,
      members: [widget.item.wallet],
    ).then((value) {
      pop();

      ref.read(chatRoomProvider).onRefreshRoom(value);
      showMyDialog(
        context: context,
        title: 'Remove User',
        message: value == null
            ? 'Cannot remove member'
            : 'Member removed successfully',
      );
    });
  }

  _removeAdmin() {
    showLoadingDialog();
    removeAdmins(
      chatId: widget.chatId!,
      admins: [widget.item.wallet],
    ).then((value) {
      pop();

      ref.read(chatRoomProvider).onRefreshRoom(value);
      showMyDialog(
        context: context,
        title: 'Remove User',
        message: value == null
            ? 'Cannot remove admin'
            : 'Admin removed successfully',
      );
    });
  }
}

class GroupPendingMembersView extends StatelessWidget {
  const GroupPendingMembersView({
    super.key,
    required this.pendingMembers,
    required this.isUserAdmin,
    required this.chatId,
  });

  final List<MemberDTO> pendingMembers;
  final bool isUserAdmin;
  final String? chatId;

  @override
  Widget build(BuildContext context) {
    return pendingMembers.isEmpty
        ? Center(
            child: Text('No members in group'),
          )
        : ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            padding: EdgeInsets.symmetric(vertical: 16),
            itemCount: pendingMembers.length,
            itemBuilder: (context, index) {
              final item = pendingMembers[index];
              return ListTile(
                leading: ProfileImage(imageUrl: item.image),
                title: Text('${item.wallet}'),
              );
            },
          );
  }
}
