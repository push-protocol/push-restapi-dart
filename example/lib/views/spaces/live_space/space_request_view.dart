import 'package:blockies/blockies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../__lib.dart';

class SpaceMicRequestsView extends ConsumerStatefulWidget {
  const SpaceMicRequestsView({
    super.key,
  });

  @override
  ConsumerState<SpaceMicRequestsView> createState() =>
      _SpaceMicRequestsViewState();
}

class _SpaceMicRequestsViewState extends ConsumerState<SpaceMicRequestsView> {
  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(liveSpaceProvider);
    final micRequests = vm.micRequests;
    return Container(
      height: 640,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.purple.withOpacity(.5),
              ]),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
          color: Colors.white),
      child: Column(
        children: [
          KText(
            'Requests',
            weight: FontWeight.w600,
            size: 16,
          ),
          SizedBox(height: 16),
          Expanded(
            child: micRequests.isEmpty
                ? Center(
                    child: KText('No requests found'),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) {
                      final item = micRequests[index];
                      return Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            Container(
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(64),
                                child: Blockies(
                                  seed: item.address,
                                  size: 4,
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            Expanded(
                                child: Column(
                              children: [
                                KText(item.address),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                showLoadingDialog();
                                                ref
                                                    .read(liveSpaceProvider)
                                                    .acceptPromotionRequest(
                                                        promoteeAddress:
                                                            item.address)
                                                    .then((value) {
                                                  pop();
                                                });
                                              },
                                              child: Text(
                                                "Promote to Speaker",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                ref
                                                    .read(liveSpaceProvider)
                                                    .rejectPromotionRequest(
                                                        promoteeAddress:
                                                            item.address);
                                              },
                                              child: Text(
                                                'Reject',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ))
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 4),
                    itemCount: micRequests.length),
          ),
        ],
      ),
    );
  }
}
