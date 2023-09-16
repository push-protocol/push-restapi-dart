import 'package:push_restapi_dart/push_restapi_dart.dart';

import '../../__lib.dart';

class ChatRequestScreen extends StatefulWidget {
  const ChatRequestScreen({super.key});

  @override
  State<ChatRequestScreen> createState() => _ChatRequestScreenState();
}

class _ChatRequestScreenState extends State<ChatRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
      ),
      body: FutureBuilder<List<Feeds>?>(
        future: requests(toDecrypt: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return Center(child: Text('Cannot load Requests'));
          }
          final spaces = snapshot.data!;

          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 32),
            separatorBuilder: (context, index) => Divider(),
            itemCount: spaces.length,
            itemBuilder: (context, index) {
              final item = spaces[index];
              final image = item.groupInformation?.groupImage ??
                  item.profilePicture ??
                  '';

              return ListTile(
                onTap: () {
                  // pushScreen(ChatRoomScreen(room: item));
                  onAccetRequests(item.groupInformation!.chatId!);
                  // onAccetRequests(item.intentSentBy!);
                },
                leading: ProfileImage(imageUrl: image),
                title: Text(
                    '${item.groupInformation?.groupName ?? item.intentSentBy}'),
                subtitle:
                    Text(item.msg?.messageContent ?? 'Send first message'),
              );
            },
          );
        },
      ),
    );
  }

  onAccetRequests(String senderAddress) async {
    try {
      showLoadingDialog(context);
      final result = await approve(senderAddress: senderAddress);
      print('onAccetRequests: $result');
      pop(context);
      showMyDialog(
        context: context,
        title: 'Approve Request',
        message: result ?? 'Approve failed',
      );
    } catch (e) {
      print('onAccetRequests: Errors $e');
      showMyDialog(
        context: context,
        title: 'Approve Request Error',
        message: '$e',
      );
      pop(context);
    }
  }
}
