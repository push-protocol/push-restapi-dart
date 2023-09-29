import 'package:example/__lib.dart';
import 'package:example/views/account_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  const ChatRoomScreen({super.key, required this.room});

  final Feeds room;

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  late Feeds room;

  @override
  void initState() {
    room = widget.room;

    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final myAddress = ref.read(accountProvider).pushWallet?.address;
    final roomVm = ref.watch(chatRoomProvider);
    final messageList = roomVm.messageList;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          if (room.groupInformation != null)
            InkWell(
              onTap: () {
                _scaffoldKey.currentState!
                    .showBottomSheet((context) => GroupMembersDialog(
                          groupInformation: room.groupInformation!,
                        ));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.people,
                  color: Colors.white,
                ),
              ),
            )
        ],
        title: Text('${room.groupInformation?.groupName ?? room.intentSentBy}'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                    child: roomVm.isLoading && messageList.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : messageList.isEmpty
                            ? Center(
                                child: Text('No messages found '),
                              )
                            : ListView.separated(
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 4),
                                itemCount: messageList.length,
                                reverse: true,
                                itemBuilder: (context, index) {
                                  final item = messageList[index];
                                  bool isSender =
                                      'eip155:$myAddress' == item.fromDID;

                                  return ChatBubble(
                                    clipper: ChatBubbleClipper1(
                                        type: isSender
                                            ? BubbleType.sendBubble
                                            : BubbleType.receiverBubble),
                                    alignment: isSender
                                        ? Alignment.topRight
                                        : Alignment.topLeft,
                                    backGroundColor: Colors.blue,
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: isSender
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          if (!isSender)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0),
                                              child: Text(
                                                pCAIP10ToWallet(
                                                    '${item.fromDID}'),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8,
                                                ),
                                              ),
                                            ),
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.end,
                                            children: [
                                              Text(
                                                '${item.messageContent}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  formatDateTime(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            item.timestamp!),
                                                  ),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 8,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )),
                SizedBox(
                  height: 24,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: roomVm.controller,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          if (!roomVm.isSending) {
                            roomVm.onSendMessage();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepPurple,
                          ),
                          child: roomVm.isSending
                              ? CupertinoActivityIndicator(color: Colors.white)
                              : Center(
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String formatDateTime(DateTime date, [String? format]) {
  final DateFormat dateFormat = DateFormat(format ?? 'dd MMM @ hh:mm');

  return dateFormat.format(date);
}
