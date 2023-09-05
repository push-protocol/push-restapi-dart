import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';
import '../__lib.dart';

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
            padding: EdgeInsets.symmetric(vertical: 32),
            separatorBuilder: (context, index) => SizedBox(),
            itemCount: spaces.length,
            itemBuilder: (context, index) {
              final item = spaces[index];
              return ListTile(
                onTap: () => onStart(item),
                title: Text('${item.spaceInformation?.spaceName}'),
                subtitle: Column(
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
      pushScreen(
          context,
          LiveSpaceRoom(
            space: value,
          ));
    }).catchError(
      (err) {
        Navigator.pop(context);
      },
    );
  }
}
