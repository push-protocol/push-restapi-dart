import 'dart:typed_data';

import '../../__lib.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {

  List<Feeds> spaces = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: MaterialButton(
      //   height: 64,
      //   color: Colors.purple,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      //   onPressed: () {
      //     pushScreen(StartP2PChatScreen());
      //   },
      //   textColor: Colors.white,
      //   child: Text('Start New Chat'),
      //   padding: EdgeInsets.all(16),
      // ),
      appBar: AppBar(title: Text('Conversations')),
      body: FutureBuilder<List<Feeds>?>(
        future: chats(toDecrypt: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && spaces.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return Center(child: Text('Cannot load Conversations'));
          }
           spaces = snapshot.data!;

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
                  pushScreen(ChatRoomScreen(room: item)).then((value) {
                    setState(() {});
                  });
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
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key, required this.imageUrl});
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purpleAccent),
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(
          Icons.person,
          color: Colors.purple,
        ),
      );
    }
    try {
      if (imageUrl!.startsWith('https://')) {
        return Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purpleAccent),
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(
                imageUrl!,
              ),
              fit: BoxFit.cover,
            ),
          ),
        );
      }

      final UriData? data = Uri.parse(imageUrl!).data;

      Uint8List myImage = data!.contentAsBytes();

      return Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purpleAccent),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: MemoryImage(
              myImage,
            ),
            fit: BoxFit.cover,
          ),
        ),
      );
    } catch (e) {
      return Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purpleAccent),
          shape: BoxShape.circle,
          color: Colors.purple,
        ),
      );
    }
  }
}
