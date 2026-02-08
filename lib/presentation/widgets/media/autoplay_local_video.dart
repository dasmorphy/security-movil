import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:zentinel/domain/entities/user_session.dart';
import 'package:zentinel/presentation/providers/auth/auth_provider.dart';

class VideoHeader extends ConsumerStatefulWidget {
  const VideoHeader({super.key});

  @override
  ConsumerState<VideoHeader> createState() => _VideoHeaderState();
}

class _VideoHeaderState extends ConsumerState<VideoHeader> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('lib/assets/videos/obg.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller
          ..setLooping(true)
          ..setVolume(0)
          ..play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final authState = ref.watch(userSessionProvider);

    return authState.when(
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
      data: (userData) {
        if (userData == null) {
          return const SizedBox(); // evita crash mientras navega
        }

        final headerHeight = MediaQuery.of(context).size.height * 0.26;

        return SizedBox(
          height: headerHeight,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_controller.value.isInitialized)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: -150,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: 650,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),

                Container(color: Colors.black.withOpacity(0.35)),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hola,',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                userData.attributes['fullname'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
