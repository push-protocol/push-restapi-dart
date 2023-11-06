import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

import '../../__lib.dart';

class TrendingSpaceScreen extends ConsumerStatefulWidget {
  const TrendingSpaceScreen({super.key});

  @override
  ConsumerState<TrendingSpaceScreen> createState() =>
      _TrendingSpaceScreenState();
}

class _TrendingSpaceScreenState extends ConsumerState<TrendingSpaceScreen> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trending Spaces'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: [
            InputField(
              controller: controller,
              label: 'Enter Space address ',
              hintText:
                  'eg. spaces:466beec0d0bc78d5ba362628a5607ece464eb723e1a2ba5fbb476202866657c5',
              suffixIcon: TextButton(
                child: KText(
                  'Join',
                  color: Colors.purple,
                  weight: FontWeight.w600,
                ),
                onPressed: () {
                  onJoin(controller.text);
                },
              ),
            ),
            SizedBox(height: 32),
            Expanded(
              child: FutureBuilder<List<SpaceFeeds>?>(
                future: trendingSpaces(limit: 30),
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
                    separatorBuilder: (context, index) => SizedBox(height: 12),
                    itemCount: spaces.length,
                    itemBuilder: (context, index) =>
                        SpaceItemTile(item: spaces[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  onJoin(String spaceId) {
    showLoadingDialog(context);
    ref
        .read(liveSpaceProvider.notifier)
        .join(
          spaceId: spaceId,
        )
        .then((value) {
      Navigator.pop(context);
      if (value == null) {
        showMyDialog(context: context, title: 'Error', message: 'Cannot Join');
      } else {
        pushScreen(LiveSpaceRoom(space: value));
      }
    }).catchError((e) {
      Navigator.pop(context);
    });
  }
}
