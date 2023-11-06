import 'dart:convert';
import 'dart:typed_data';

import 'package:example/__lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    room = widget.room;

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatRoomProvider).setCurrentChat(room);
    });
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
                    .showBottomSheet((context) => GroupMembersDialog());
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
                                              Builder(builder: (context) {
                                                if (item.messageType ==
                                                    MessageType.IMAGE) {
                                                  final content = jsonDecode(
                                                      item.messageContent);
                                                  final imgUrl =
                                                      content['content'];
                                                  print(imgUrl);
                                                  return _ChatImage(
                                                    imageUrl:
                                                        content['content'],
                                                  );
                                                } else {
                                                  return Text(
                                                    '${item.messageContent}',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  );
                                                }
                                              }),
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
                SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: roomVm.selectedFile != null
                          ? Stack(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.file(
                                        roomVm.selectedFile!,
                                        width: 78,
                                        height: 78,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        '${roomVm.selectedFile?.uri.pathSegments.last}',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                    right: 8,
                                    top: 8,
                                    child: InkWell(
                                      onTap: roomVm.clearSelectedFile,
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ))
                              ],
                            )
                          : TextField(
                              controller: roomVm.controller,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 5,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                suffixIcon: InkWell(
                                  onTap: roomVm.onSelectFile,
                                  child: Icon(Icons.attachment),
                                ),
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

class _ChatImage extends StatelessWidget {
  const _ChatImage({
    required this.imageUrl,
  });
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      child: Builder(builder: (context) {
        if (imageUrl == null) {
          return Image.asset(
            AppAssets.ASSETS_EPNSLOGO_PNG,
            fit: BoxFit.fill,
          );
        }
        try {
          if (imageUrl!.startsWith('https://')) {
            return Image.network(imageUrl!);
          }

          return Image.memory(
            dataFromBase64String(imageUrl!),
            fit: BoxFit.fill,
          );
        } catch (e) {
          return Image.asset(
            AppAssets.ASSETS_EPNSLOGO_PNG,
            color: Colors.red,
          );
        }
      }),
    );
  }
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}
