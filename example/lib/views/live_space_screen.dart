import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

class LiveSpaceRoom extends ConsumerStatefulWidget {
  final SpaceDTO space;

  LiveSpaceRoom({required this.space});

  @override
  ConsumerState<LiveSpaceRoom> createState() => _LiveSpaceRoomState();
}

class _LiveSpaceRoomState extends ConsumerState<LiveSpaceRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Space'),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(child: Column()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    MaterialButton(
                      color: Colors.purple,
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.people,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    Text('Participants')
                  ],
                ),
                SizedBox(width: 16),
                Consumer(builder: (context, ref, child) {
                  final vm = ref.watch(PushSpaceProvider);
                  bool isSpeaker = vm.isSpeakerConnected;

                  if (isSpeaker) {
                    bool isMicOn = vm.isMicOn;
                    return Column(
                      children: [
                        MaterialButton(
                          padding: EdgeInsets.all(16),
                          color: Colors.white,
                          shape: CircleBorder(),
                          child: Icon(
                            isMicOn ? Icons.mic : Icons.mic_off,
                            size: 32,
                          ),
                          onPressed:
                              ref.read(PushSpaceProvider.notifier).toggleMic,
                        ),
                        Text('Mic')
                      ],
                    );
                  }
                  return SizedBox.shrink();
                }),
                SizedBox(width: 16),
                Column(
                  children: [
                    MaterialButton(
                      color: Colors.red,
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    Text('Leave')
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
