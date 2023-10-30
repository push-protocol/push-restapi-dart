// import 'package:better_player/better_player.dart';
import 'package:blockies/blockies.dart';
import 'package:clipboard/clipboard.dart';
import 'package:example/__lib.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as m;

class LiveSpaceRoom extends ConsumerStatefulWidget {
  final SpaceDTO space;

  LiveSpaceRoom({required this.space});

  @override
  ConsumerState<LiveSpaceRoom> createState() => _LiveSpaceRoomState();
}

class _LiveSpaceRoomState extends ConsumerState<LiveSpaceRoom>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;

  bool _showReaction = false;

  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(liveSpaceProvider);
    final SpaceDTO data = widget.space;
    final liveSpaceData = vm.liveSpaceData;
    final host = liveSpaceData.host;
    final speakers = liveSpaceData.speakers;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Transform.rotate(
                        angle: m.pi / -2,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: KText(
                        data.spaceName,
                        maxLines: 2,
                        size: 16,
                        weight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InkWell(
                      onTap: onLeaveSpace,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: KText(
                          'Leave',
                          color: Colors.red,
                          weight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 10,
                        children: [
                          _HostCard(host: host),
                          ...speakers.map(
                            (speaker) => _SpeakerCard(speaker: speaker),
                          )
                        ],
                      ),
                      SizedBox(height: 12),
                      DataView(
                        label: 'Space Id:',
                        value: data.spaceId,
                      ),
                      SizedBox(height: 12),
                      DataView(
                        label: 'Space Description:',
                        value: data.spaceDescription ?? '',
                      ),
                      SizedBox(height: 12),
                      DataView(
                          label: 'Space Creator', value: data.spaceCreator),
                      SizedBox(height: 24),
                      SizedBox(height: 12),
                      Divider(),
                      if (vm.reactions.isNotEmpty)
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children:
                                  vm.reactions.map((e) => Text(e)).toList(),
                            )),
                    ],
                  ),
                ),
                /*
                Consumer(
                  builder: (context, ref, child) {
                    final vm = ref.watch(liveSpaceProvider);

                    if (vm.spacePlaybackUrl != null) {
                      if (_controller == null) {
                        _controller = VideoPlayerController.networkUrl(
                          Uri.parse(vm.spacePlaybackUrl!),
                          formatHint: VideoFormat.hls,
                          videoPlayerOptions: VideoPlayerOptions(
                              allowBackgroundPlayback: true),
                        )..initialize().then((_) {
                            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                            setState(() {});
                          });
                        return SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          SizedBox(
                            height: 100,
                            child: _controller!.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio:
                                        _controller!.value.aspectRatio,
                                    child: VideoPlayer(_controller!),
                                  )
                                : SizedBox.shrink(),
                          ),
                          MaterialButton(
                            padding: EdgeInsets.all(16),
                            color: Colors.white,
                            shape: CircleBorder(),
                            child: Icon(
                              Icons.play_arrow,
                              size: 32,
                            ),
                            onPressed: () {
                              _controller!.play();
                            },
                          ),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),*/
              ],
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Consumer(builder: (context, ref, child) {
                    final vm = ref.watch(liveSpaceProvider);
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
                                ref.read(liveSpaceProvider.notifier).toggleMic,
                          ),
                          Text('Mic')
                        ],
                      );
                    } else if (vm.isListenerConnected) {
                      if (_controller == null) {
                        _controller = VideoPlayerController.networkUrl(
                          Uri.parse(vm.spacePlaybackUrl!),
                          formatHint: VideoFormat.hls,
                          videoPlayerOptions:
                              VideoPlayerOptions(allowBackgroundPlayback: true),
                        )..initialize().then((_) {
                            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                            setState(() {});
                            _controller?.play();
                          });
                      }

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              MaterialButton(
                                padding: EdgeInsets.all(16),
                                color: Colors.purpleAccent,
                                textColor: Colors.white,
                                shape: CircleBorder(),
                                child: Icon(
                                  Icons.mic,
                                  size: 32,
                                ),
                                onPressed: () {},
                              ),
                              Text('Request')
                            ],
                          ),

                          ///Video player is needed in the View to stream space as listener
                          SizedBox(
                            height: 10,
                            width: 10,
                            child: _controller!.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio: _controller!.value.aspectRatio,
                                    child: VideoPlayer(_controller!),
                                  )
                                : SizedBox.shrink(),
                          ),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  }),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        FlutterClipboard.copy(data.spaceId).then((value) {
                          showSuccessSnackbar('Space Id copied successfully');
                        });
                      },
                      child: Icon(Icons.share)),
                  SizedBox(width: 24),
                  AnimatedContainer(
                    duration: Duration(seconds: 2),
                    child: _showReaction
                        ? Column(
                            children: [
                              ...[
                                CHAT.REACTION_ANGRY,
                                CHAT.REACTION_CLAP,
                                CHAT.REACTION_FIRE,
                                CHAT.REACTION_HEART,
                                CHAT.REACTION_LAUGH,
                                CHAT.REACTION_SAD,
                                CHAT.REACTION_SURPRISE,
                                CHAT.REACTION_THUMBSDOWN,
                                CHAT.REACTION_THUMBSUP,
                              ]
                                  .map(
                                    (emoji) => InkWell(
                                      onTap: () {
                                        ref
                                            .read(liveSpaceProvider)
                                            .sendReaction(reaction: emoji);
                                      },
                                      child: Text(
                                        emoji,
                                        style: TextStyle(fontSize: 32),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              SizedBox(height: 8),
                              InkWell(
                                onTap: onHideReaction,
                                child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.grey)),
                                    child:
                                        Icon(Icons.close, color: Colors.grey)),
                              )
                            ],
                          )
                        : InkWell(
                            onTap: onShowReaction,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.emoji_emotions,
                                  size: 32,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void onHideReaction() {
    setState(() {
      _showReaction = false;
    });
  }

  void onShowReaction() {
    _showReaction = true;
    setState(() {});
  }

  onLeaveSpace() async {
    showLoadingDialog(context);
    await ref.read(liveSpaceProvider).leave().then((value) {
      showMyDialog(
        context: context,
        title: 'Space',
        message: 'Leave space success',
        onClose: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
    });
  }
}

class DataView extends StatelessWidget {
  const DataView({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });
  final Color? color;
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: color ?? Colors.grey[700]),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _HostCard extends StatelessWidget {
  const _HostCard({
    required this.host,
  });

  final AdminPeer host;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.purple,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                      seed: '${host.address}',
                      size: 4,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Host',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  host.audio == true ? Icons.mic : Icons.mic_off,
                ),
              ))
        ],
      ),
    );
  }
}

class _SpeakerCard extends StatelessWidget {
  const _SpeakerCard({
    required this.speaker,
  });

  final AdminPeer speaker;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.purple[500],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        seed: '${speaker.address}',
                        size: 4,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      '${speaker.address}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                speaker.audio == true ? Icons.mic : Icons.mic_off,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
