import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:zentinel/presentation/providers/onboarding/onboarding_provider.dart';
import 'package:zentinel/presentation/screens/screens.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class StepPhoto extends ConsumerStatefulWidget {
  final VoidCallback previousPage;
  final VoidCallback nextPage;

  const StepPhoto({
    super.key,
    required this.previousPage,
    required this.nextPage,
  });

  @override
  ConsumerState<StepPhoto> createState() => _StepPhotoState();
}

class _StepPhotoState extends ConsumerState<StepPhoto> {
  late VideoPlayerController _controllerVideo;
  File? photo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controllerVideo =
        VideoPlayerController.asset('assets/videos/escudofoto.mp4')
          ..initialize().then((_) {
            setState(() {});
            _controllerVideo
              ..setLooping(true)
              ..setVolume(0)
              ..play();
          });
  }

  @override
  void dispose() {
    _controllerVideo.dispose();
    super.dispose();
  }

  Future<void> takePhoto() async {
    final File? result = await Navigator.push<File>(
      context,
      MaterialPageRoute(builder: (_) => const CameraScreen()),
    );

    if (result != null) {
      setState(() => photo = result);
    }
  }

  Future<void> finish() async {
    if (photo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor captura una foto'),
          backgroundColor: Color.fromARGB(255, 219, 66, 19),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(onboardingProvider.notifier)
          .saveUserProfile(photoPath: photo!.path);

      // Pequeño delay para asegurar que Hive persista los datos
      await Future.delayed(const Duration(milliseconds: 500));

      // Invalidar el provider para que se refresque con los nuevos datos
      ref.invalidate(userProfileProvider);
      widget.nextPage();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: const Color.fromARGB(255, 219, 66, 19),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final userName = ref.watch(userNameProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: context.isDarkMode
              ? const [
                  Color.fromARGB(255, 15, 32, 39),
                  Color.fromARGB(255, 32, 47, 56),
                ]
              : const [Color(0xFFE3F2F2), Color(0xFFF7FBFB)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header con saludo personalizado
              // Padding(
              //   padding: const EdgeInsets.only(top: 80),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           Text(
              //             '¡Hola, $userName! 👋',
              //             style: const TextStyle(
              //               fontSize: 18,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.white,
              //             ),
              //           ),
              //         ],
              //       ),
              //       const SizedBox(height: 4),
              //       Text(
              //         'Ya casi terminamos',
              //         style: TextStyle(
              //           fontSize: 13,
              //           color: Colors.white.withOpacity(0.7),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Center content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.primary.withOpacity(0.3),
                            blurRadius: 50,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: PulsingLogo(
                        child: ClipOval(
                          child: SizedBox(
                            width: 140,
                            height: 140,
                            child: _controllerVideo.value.isInitialized
                                ? FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: _controllerVideo.value.size.width,
                                      height:
                                          _controllerVideo.value.size.height,
                                      child: VideoPlayer(_controllerVideo),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Tu foto de ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        TextSpan(
                          text: 'perfil',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Captura una foto clara desde tu cámara',
                    style: TextStyle(fontSize: 14, color: context.colors.textPrimary.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: takePhoto,
                      child: photo != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                photo!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: context.colors.primary,
                                  width: 2,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    size: 50,
                                    color: context.colors.primary,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Toca para agregar\ntu foto',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Info bullets
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 6, right: 12),
                        decoration: BoxDecoration(
                          color: context.colors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Identifica tu cuenta fácilmente',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 6, right: 12),
                        decoration: BoxDecoration(
                          color: context.colors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Personaliza tu experiencia',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ElevatedButton.icon(
                  //   onPressed: takePhoto,
                  //   icon: const Icon(Icons.camera_alt),
                  //   label: const Text(
                  //     'Capturar foto',
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  //   style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(vertical: 16),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //     backgroundColor: context.colors.primary,
                  //   ),
                  // ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: _isLoading ? null : finish,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: context.colors.primary,
                      // disabledBackgroundColor: Colors.green.withOpacity(0.4),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Siguiente →',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => widget.previousPage(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.transparent,
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Atrás',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
