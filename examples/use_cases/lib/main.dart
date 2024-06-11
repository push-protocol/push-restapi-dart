import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:use_cases/chats/chat.dart';

import 'pushAPI/notificaton/notification.test.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(const MainApp());
  runNotificationTest();

  return;

  log(r'''

          ░█████╗░██╗░░██╗░█████╗░████████╗
          ██╔══██╗██║░░██║██╔══██╗╚══██╔══╝
          ██║░░╚═╝███████║███████║░░░██║░░░
          ██║░░██╗██╔══██║██╔══██║░░░██║░░░
          ╚█████╔╝██║░░██║██║░░██║░░░██║░░░
          ░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░
        ''');

  await runChatClassUseCases();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Push'),
        ),
      ),
    );
  }
}
