import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../__lib.dart';

class SpacesTab extends ConsumerStatefulWidget {
  const SpacesTab({super.key});

  @override
  ConsumerState<SpacesTab> createState() => _SpacesTabState();
}

class _SpacesTabState extends ConsumerState<SpacesTab> {
  @override
  Widget build(BuildContext context) {

    final requestsCount =
        ref.watch(spaceRequestsProvider).requestsList?.length ?? 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                pushScreen(CreateSpaceScreen());
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/talk.png',
                      height: 24,
                      width: 24,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    KText(
                      'Create Space',
                      color: Colors.white,
                      size: 18,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            InkWell(
              onTap: () {
                Get.bottomSheet(SpaceInvitesDailog());
                // pushScreen(SpaceInvitesScreen());
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.multitrack_audio_outlined,
                      size: 30,
                    ),
                  ),
                  if (requestsCount > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Text(
                          requestsCount.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );

    /*  ListView.separated(
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final item = actions[index];
        return ListTile(
          tileColor: Colors.white,
          title: Text(item.title),
          onTap: item.onPressed,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.count > 0)
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Text(
                    item.count.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 8),
    );*/
  }
}

final buttonColor = Color(0xFFD43A94);
