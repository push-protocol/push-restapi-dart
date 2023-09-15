import 'package:example/__lib.dart';
import 'package:example/views/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      updateLoading(true);
      final options = ChatSendOptions(
          messageContent: controller.text.trim(),
          receiverAddress: room.chatId!);
      final message = await send(options);
      updateLoading(false);

      if (message != null) {
        controller.clear();
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
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : messageList.isEmpty
                          ? Center(
                              child: Text('No messages found '),
                            )
                          : ListView.builder(
                              itemCount: texts.length,
                              reverse: true,
                              itemBuilder: (context, index) {
                                final item = texts[index];
                                bool isSender = myAddress == item.fromDID;

                                return ChatBubble(
                                  clipper: ChatBubbleClipper1(
                                      type: isSender
                                          ? BubbleType.sendBubble
                                          : BubbleType.receiverBubble),
                                  alignment: isSender
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  margin: EdgeInsets.only(top: 20),
                                  backGroundColor: Colors.blue,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${item.messageContent}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          '${DateTime.fromMillisecondsSinceEpoch(item.timestamp!)}',
                                          style: TextStyle(color: Colors.white),
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
                label: '',
                suffixIcon: InkWell(
                    onTap: () {
                      if (!isLoading) {
                        onSendMessage();
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: isLoading ? null : Colors.pinkAccent,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
