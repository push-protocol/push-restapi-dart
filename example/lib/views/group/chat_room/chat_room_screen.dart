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

  @override
  Widget build(BuildContext context) {
    final myAddress = ref.read(accountProvider).pushWallet?.address;
    final roomVm = ref.watch(chatRoomProvider);
    final messageList = roomVm.messageList;

    return Scaffold(
      appBar: AppBar(
        title: Text('${room.groupInformation?.groupName ?? room.intentSentBy}'),
      ),
      body: SafeArea(
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
                                    margin: EdgeInsets.all(8),
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
                                        Text(
                                          '${item.messageContent}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          formatDateTime(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  item.timestamp!)),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
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
              InputField(
                controller: roomVm.controller,
                label: '',
                suffixIcon: InkWell(
                    onTap: () {
                      if (!roomVm.isSending) {
                        roomVm.onSendMessage();
                      }
                    },
                    child: roomVm.isSending
                        ? CupertinoActivityIndicator()
                        : Icon(
                            Icons.send,
                            color: Colors.pinkAccent,
                          )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String formatDateTime(DateTime date, [String? format]) {
  final DateFormat dateFormat = DateFormat(format ?? 'hh:mm');

  return dateFormat.format(date);
}
