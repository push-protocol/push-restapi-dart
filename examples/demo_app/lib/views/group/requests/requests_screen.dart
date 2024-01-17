import 'package:push_restapi_dart/push_restapi_dart.dart';

import '../../../__lib.dart';

class ChatRequestsTab extends ConsumerStatefulWidget {
  const ChatRequestsTab({
    super.key,
  });

  @override
  ConsumerState<ChatRequestsTab> createState() => _ChatRequestsTabState();
}

class _ChatRequestsTabState extends ConsumerState<ChatRequestsTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final vm = ref.watch(requestsProvider);
        final requestsList = vm.requestsList;
        if (vm.isBusy && (requestsList ?? []).isEmpty) {
          return Center(
            child: LoadingDialog(),
          );
        }
        if (requestsList == null) {
          return Center(child: Text('Cannot load Requests'));
        }

        return RefreshIndicator(
          onRefresh: vm.loadRequests,
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: requestsList.length,
            itemBuilder: (context, index) {
              final item = requestsList[index];
              final image =
                  item.groupInformation?.groupImage ?? item.profilePicture;

              return InkWell(
                  onTap: () {
                    onAccetRequests(item.chatId!);
                  },
                  child: ConversationTile(
                    image: image,
                    item: item,
                    subText: 'Tap to Accept Request',
                  ));
            },
          ),
        );
      },
    );
  }

  PushAPI get pushUser => ref.read(accountProvider).pushUser!;
  onAccetRequests(String senderAddress) async {
    try {
      showLoadingDialog(context);
      final result = await pushUser.chat.accept(target: senderAddress);
      print('onAccetRequests: $result');
      pop(context);
      showMyDialog(
        context: context,
        title: 'Approve Request',
        message: result ?? 'Approve failed',
      );
    } catch (e) {
      print('onAccetRequests: Errors $e');
      showMyDialog(
        context: context,
        title: 'Approve Request Error',
        message: '$e',
      );
      pop(context);
    }

    ref.read(requestsProvider).loadRequests();
    ref.read(conversationsProvider).loadChats();
  }
}
