import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:zentinel/config/constants/permissions.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/providers/auth/auth_provider.dart';
import 'package:zentinel/presentation/providers/onboarding/onboarding_provider.dart';
import 'package:zentinel/presentation/widgets/modals/dispatch_offline.dart';
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
          loading: () => const Center(child: CircularProgressIndicator()),
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
                                InkWell(
                                  onTap: () async {
                                    if (isLoading) return;

                                    final option = await OptionBottomSheet.show<String>(
                                      context,
                                      options: [
                                        if (userData.hasPermission(Permissions.bitacorasOffline))
                                          BottomSheetOption(
                                            value: 'BITACORAS',
                                            label: 'Bitácoras',
                                            icon: Icons.document_scanner_rounded,
                                          ),
                                        if (userData.hasPermission(Permissions.personalInternoOffline))
                                          BottomSheetOption(
                                            value: 'PERSONAL_INTERNO',
                                            label: 'Personal interno',
                                            icon: Icons.person_outline,
                                          ),
                                        if (userData.hasPermission(Permissions.dispatchOffline))
                                          BottomSheetOption(
                                            value: 'DESPACHO_INGRESO',
                                            label: 'Despachos e ingresos',
                                            icon: Icons.assignment_turned_in_rounded,
                                          ),
                                        if (userData.hasPermission(Permissions.registerTechnicalOffline))
                                          BottomSheetOption(
                                            value: 'REGISTROS_TECNICOS',
                                            label: 'Registros técnicos',
                                            icon: Icons.assignment_turned_in_rounded,
                                          ),
                                      ],
                                    );

                                    if (option == null) return;

                                    if (option == 'BITACORAS') {
                                      if (context.mounted) {
                                        _openModal(
                                          context,
                                          LogbooksOfflineListModal(),
                                        );
                                      }
                                    }

                                    if (option == 'PERSONAL_INTERNO') {
                                      if (context.mounted) {
                                        _openModal(
                                          context,
                                          EmployeeMovementOffline(),
                                        );
                                      }
                                    }

                                    if (option == 'DESPACHO_INGRESO') {
                                      if (context.mounted) {
                                        _openModal(context, DispatchOffline());
                                      }
                                    }

                                    if (option == 'REGISTROS_TECNICOS') {
                                      if (context.mounted) {
                                        _openModal(context, RegisterTecninalOffline());
                                      }
                                    }
                                  },

                                  child: const Padding(
                                    padding: EdgeInsets.all(7),
                                    child: Icon(
                                      Icons.cloud_sync,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                InkWell(
                                  onTap: () async {
                                    context.push('/notifications');
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(7),
                                    child: Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 15),
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
          },
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
