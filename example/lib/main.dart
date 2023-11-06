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
        appBarTheme: AppBarTheme(backgroundColor: Colors.purple),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.purple,
          indicatorColor: Colors.purple,
          unselectedLabelColor: Colors.purple,
          indicator: BoxDecoration(
              border: Border.all(
                color: Colors.purple,
              ),
              borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
