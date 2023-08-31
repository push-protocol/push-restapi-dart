import 'package:example/__lib.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

class MySpacesScreen extends ConsumerStatefulWidget {
  const MySpacesScreen({super.key});

  @override
  ConsumerState<MySpacesScreen> createState() => _MySpacesScreenState();
}

class _MySpacesScreenState extends ConsumerState<MySpacesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Spaces'),
      ),
      body: FutureBuilder<List<SpaceFeeds>?>(
        future: spaceFeeds(toDecrypt: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return Center(child: Text('Cannot load Spaces'));
          }
          final spaces = snapshot.data!;

          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 16),
            separatorBuilder: (context, index) => SizedBox(),
            itemCount: spaces.length,
            itemBuilder: (context, index) {
              final item = spaces[index];
              return ListTile(
                onTap: () {
                  ref.read(PushSpaceProvider.notifier).start(
                        spaceId: item.spaceId!,
                        progressHook: (p0) {},
                      );
                },
                title: Text('${item.name}'),
                subtitle: Text('${item.spaceId}'),
              );
            },
          );
        },
      ),
    );
  }
}
