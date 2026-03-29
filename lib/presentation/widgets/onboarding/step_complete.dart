import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:zentinel/presentation/providers/onboarding/onboarding_provider.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class StepComplete extends ConsumerStatefulWidget {
  const StepComplete({super.key});

  @override
  ConsumerState<StepComplete> createState() => _StepCompleteState();
}

class _StepCompleteState extends ConsumerState<StepComplete> {
  late VideoPlayerController _controllerVideo;

  @override
  void initState() {
    super.initState();

    _controllerVideo =
        VideoPlayerController.asset('assets/videos/escudofinish.mp4')
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

  @override
  Widget build(BuildContext context) {
    final userName = ref.watch(userNameProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 15, 32, 39),
            Color.fromARGB(255, 32, 47, 56),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// VIDEO + ANIMACION
                  Center(
                    child: Container(
                      // margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              189,
                              7,
                              213,
                              213,
                            ).withOpacity(0.3),
                            blurRadius: 50,
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

                  /// TITULO
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: '¡Todo ',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const TextSpan(
                          text: 'listo',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(189, 7, 213, 213),
                          ),
                        ),
                        TextSpan(
                          text: ', $userName! 🎉',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: Text(
                      'Tu cuenta está completada y\nlista para usar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// CARD SEGURIDAD
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(189, 7, 213, 213),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.03),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.security,
                          color: Color.fromARGB(189, 7, 213, 213),
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nivel de seguridad:',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white54,
                              ),
                            ),
                            Text(
                              'Alto',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(189, 7, 213, 213),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildCheckItem('Perfil configurado correctamente'),
                  const SizedBox(height: 12),
                  _buildCheckItem('Experiencia personalizada'),
                  const SizedBox(height: 12),
                  _buildCheckItem('Menú de opciones habilitado'),
                ],
              ),
            ),

            ElevatedButton(
              onPressed: () => context.go('/'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: const Color.fromARGB(255, 76, 175, 80),
              ),
              child: const Text(
                '¡Todo listo, empecemos! →',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            color: Color.fromARGB(189, 7, 213, 213),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 12),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
