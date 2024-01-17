import 'package:blockies/blockies.dart';
import 'package:intl/intl.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

import '../__lib.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: 'Chats',
              ),
              Tab(
                child: Consumer(
                  builder: (context, ref, child) {
                    final count =
                        ref.watch(requestsProvider).requestsList?.length ?? 0;

                    return Row(
                      children: [
                        Text('Requests'),
                        if (count > 0)
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: Text(
                              count.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              children: [
                ConversationsTab(),
                ChatRequestsTab(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ConversationsTab extends StatelessWidget {
  const ConversationsTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final vm = ref.watch(conversationsProvider);
        final spaces = vm.conversations;
        if (vm.isBusy && spaces.isEmpty) {
          return Center(
            child: LoadingDialog(),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await vm.loadChats();
          },
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  pushScreen(CreateGroupScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.group_add,
                        size: 32,
                        color: pushColor,
                      ),
                      SizedBox(width: 16),
                      KText(
                        'Create Group',
                        size: 20,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: spaces.isEmpty
                    ? Center(
                        child: KText('Start a conversation'),
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: spaces.length,
                        itemBuilder: (context, index) {
                          final item = spaces[index];
                          final image = item.groupInformation?.groupImage ??
                              item.profilePicture;

                          return InkWell(
                            onTap: () {
                              pushScreen(ChatRoomScreen(room: item));
                            },
                            child: ConversationTile(image: image, item: item),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.image,
    required this.item,
    this.subText,
  });

  final String? image;
  final String? subText;
  final Feeds item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
          border: Border.all(color: pushColor),
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image != null
              ? ProfileImage(imageUrl: image)
              : Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Blockies(seed: '${item.chatId}'),
                  ),
                ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(
                  '${item.groupInformation?.groupName ?? pCAIP10ToWallet('${item.name ?? item.intentSentBy}')}',
                  size: 16,
                  maxLines: 1,
                  weight: FontWeight.w600,
                ),
                SizedBox(height: 4),
                KText(
                  subText != null
                      ? subText!
                      : item.msg?.messageType == MessageType.TEXT
                          ? item.msg?.messageContent ?? 'Send first message'
                          : '${item.msg?.messageType} was sent by ${pCAIP10ToWallet(item.msg?.fromDID ?? '')}',
                  maxLines: 2,
                )
              ],
            ),
          ),
          SizedBox(width: 10),
          if (item.msg != null && item.msg?.timestamp != null)
            KText(
              '${DateFormat('dd/MM/yy').format(DateTime.fromMillisecondsSinceEpoch(item.msg!.timestamp!))}',
              size: 10,
            )
        ],
      ),
    );
  }
}
