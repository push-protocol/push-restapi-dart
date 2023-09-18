import 'package:flutter_riverpod/flutter_riverpod.dart';

import '__lib.dart';

void main() async {
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          primaryColor: Colors.purple,
          appBarTheme: AppBarTheme(backgroundColor: Colors.purple)),
      home: HomeScreen(),
    );
  }
}
