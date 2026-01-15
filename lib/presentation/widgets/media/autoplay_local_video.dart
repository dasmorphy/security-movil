import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AutoPlayLocalVideo extends StatefulWidget {
  const AutoPlayLocalVideo({super.key});

  @override
  State<AutoPlayLocalVideo> createState() => _AutoPlayLocalVideoState();
}

class _AutoPlayLocalVideoState extends State<AutoPlayLocalVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        VideoPlayerController.asset('lib/assets/videos/obg.mp4')
          ..initialize().then((_) {
            _controller
              ..setLooping(true)
              ..setVolume(0)
              ..play();
            setState(() {});
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const SizedBox.shrink();
  }
}
