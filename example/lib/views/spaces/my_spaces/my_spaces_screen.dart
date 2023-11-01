import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';
import 'package:unique_names_generator/unique_names_generator.dart';
import '../../../__lib.dart';

class MySpacesScreen extends ConsumerStatefulWidget {
  const MySpacesScreen({super.key});

  @override
  ConsumerState<MySpacesScreen> createState() => _MySpacesScreenState();
}

class _MySpacesScreenState extends ConsumerState<MySpacesScreen> {
  createRandom() async {
    showLoadingDialog(context);
    try {
      final generator = UniqueNamesGenerator(
        config: Config(dictionaries: [names, animals, colors]),
      );
      String spaceName = 'Space ${generator.generate()} '.replaceAll('_', ' ');
      if (spaceName.length > 50) {
        spaceName = spaceName.substring(0, 45);
      }

      final result = await createSpace(
        spaceName: spaceName,
        spaceDescription: "Testing dart for description for $spaceName",
        listeners: ["eip155:0x9960D6B63B113303B9910A03ca5341B83CC52723"],
        speakers: [
          '0x9e16C5B631C3328843fA7d2acc8edd100f21693a',
        ],
        isPublic: true,
        scheduleAt: DateTime.now().toUtc().add(
              Duration(minutes: 1),
            ),
      );
      if (result != null) {
        log('testCreateSpace response: spaceId = ${result.spaceId}');
        setState(() {});
      }

      await ref.read(mySpacesProvider.notifier).onRefresh();
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final spaces = ref.watch(mySpacesProvider);
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: createRandom,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Text(
            'Create Random Space',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          decoration: BoxDecoration(
              color: Colors.purple, borderRadius: BorderRadius.circular(12)),
        ),
      ),
      appBar: AppBar(
        title: Text('My Spaces'),
      ),
      body: spaces.isEmpty
          ? Center(child: Text('Cannot load Spaces'))
          : ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemCount: spaces.length,
              itemBuilder: (context, index) {
                return SpaceItemTile(item: spaces[index]);
              },
            ),
    );
  }
}
