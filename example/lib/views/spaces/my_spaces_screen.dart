import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';
import 'package:unique_names_generator/unique_names_generator.dart';
import '../../__lib.dart';

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
        spaceImage:
            "https://res.cloudinary.com/drdjegqln/image/upload/v1686227557/Push-Logo-Standard-Dark_xap7z5.png",
        listeners: ["eip155:0x9960D6B63B113303B9910A03ca5341B83CC52723"],
        speakers: [
          "eip155:0xffa1af9e558b68bbc09ad74058331c100c135280",
          '0xB6E3Dc6b35A294f6Bc8de33969185A615e8596D3',
          '0x8ca107e6845b095599FDc1A937E6f16677a90325',
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
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.symmetric(vertical: 32),
            separatorBuilder: (context, index) => SizedBox(),
            itemCount: spaces.length,
            itemBuilder: (context, index) {
              final item = spaces[index];
              return ListTile(
                onTap: () => onStart(item),
                title: Text('${item.spaceInformation?.spaceName}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item.spaceId}'),
                    Text('${item.spaceInformation?.scheduleAt}'),
                  ],
                ),
                trailing: item.spaceInformation?.status == ChatStatus.PENDING
                    ? MaterialButton(
                        shape: RoundedRectangleBorder(),
                        color: Colors.purple,
                        onPressed: () => onStart(item),
                        child: Text('Start'),
                        textColor: Colors.white,
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }

  onStart(SpaceFeeds item) {
    if (item.spaceInformation?.status != ChatStatus.PENDING) {
      showMyDialog(
          context: context,
          title: 'Error',
          message:
              'Unable to start the space as it is not in the pending state');
      return;
    }

    showLoadingDialog(context);
    ref
        .read(PushSpaceProvider.notifier)
        .start(
          spaceId: item.spaceId!,
          progressHook: (p0) {},
        )
        .then((value) {
      Navigator.pop(context);
      if (value == null) {
        showMyDialog(
            context: context, title: 'Error', message: 'Space not created');

        return;
      }
      pushScreen(LiveSpaceRoom(
        space: value,
      ));
    }).catchError(
      (err) {
        Navigator.pop(context);
      },
    );
  }
}
