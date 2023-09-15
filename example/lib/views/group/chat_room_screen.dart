import 'package:example/__lib.dart';
import 'package:example/views/account_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List<Message> messageList = <Message>[];
  @override
  void initState() {
    room = widget.room;
    getRoomMessages();
    super.initState();
  }

  bool isLoading = false;
  updateLoading(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  bool isSending = false;
  updateSending(bool state) {
    setState(() {
      isSending = state;
    });
  }

  getRoomMessages() async {
    updateLoading(true);
    final hash = await conversationHash(conversationId: room.chatId!);

    final messages = await history(
      limit: FetchLimit.MAX,
      threadhash: hash!,
      toDecrypt: true,
    );
    updateLoading(false);

    if (messages != null) {
      messageList = messages;
      setState(() {});
    }
  }

  TextEditingController controller = TextEditingController();
  onSendMessage() async {
    try {
      updateSending(true);
      final options = ChatSendOptions(
          messageContent: controller.text.trim(),
          receiverAddress: room.chatId!);
      final message = await send(options);
      updateSending(false);

      if (message != null) {
        controller.clear();
        getRoomMessages();
        setState(() {});
      }
    } catch (e) {
      updateLoading(false);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final myAddress = ref.read(accountProvider).pushWallet?.address;
    final texts = messageList.toList();

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
                  child: isLoading && messageList.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : messageList.isEmpty
                          ? Center(
                              child: Text('No messages found '),
                            )
                          : ListView.separated(
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 4),
                              itemCount: texts.length,
                              reverse: true,
                              itemBuilder: (context, index) {
                                final item = texts[index];
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
                controller: controller,
                label: '',
                suffixIcon: InkWell(
                    onTap: () {
                      if (!isSending) {
                        onSendMessage();
                      }
                    },
                    child: isSending
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
