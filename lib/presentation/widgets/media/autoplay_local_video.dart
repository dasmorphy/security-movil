import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:zentinel/config/constants/permissions.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/providers/auth/auth_provider.dart';
import 'package:zentinel/presentation/providers/onboarding/onboarding_provider.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

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
    _controller = VideoPlayerController.asset('assets/videos/obg.mp4')
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

        final headerHeight = MediaQuery.of(context).size.height * 0.24;
        final profileAsync = ref.watch(userProfileProvider(userData.email));

        return profileAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (_, __) => const SizedBox(),
          data: (userProfile) {
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (userData.hasPermission(Permissions.bitacorasOffline))...[
                                  InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () => _openModal(context, LogbooksOfflineListModal()),
                                    child: const Padding(
                                      padding: EdgeInsets.all(7),
                                      child: Icon(Icons.upload_file_rounded, color: Colors.white),
                                    ),
                                  ),
                                ]
                                else
                                  const SizedBox(),
                              ],
                            ),
                            
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 15,),
                                  const Text(
                                    'Hola,',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    userProfile?.name ??
                                      userData.attributes['fullname'] ??
                                      'Usuario',
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
          }
        );
      },
    );
  }

  void _openModal(BuildContext context, Widget childWidget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) {
        return AnimatedModal(child: childWidget);
      },
    );
  }
}
