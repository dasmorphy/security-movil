import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:zentinel/presentation/providers/onboarding/onboarding_provider.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class StepName extends ConsumerStatefulWidget {
  final VoidCallback nextPage;

  const StepName({super.key, required this.nextPage});

  @override
  ConsumerState<StepName> createState() => _StepNameState();
}

class _StepNameState extends ConsumerState<StepName> {
  final TextEditingController controller = TextEditingController();
  late VideoPlayerController _controllerVideo;

  void saveName() {
    if (controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa tu nombre'),
          backgroundColor: Color.fromARGB(255, 219, 66, 19),
        ),
      );
      return;
    }

    ref.read(userNameProvider.notifier).state = controller.text;
    widget.nextPage();
  }

  @override
  void initState() {
    super.initState();
    _controllerVideo =
        VideoPlayerController.asset('assets/videos/escribiendologo.mp4')
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
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userName = ref.read(userNameProvider);
    if (userName.isNotEmpty) {
      controller.text = userName;
    }

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
            children: [
              // Center content
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 60),
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

                  // Header section
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '¡Hola! ¿Cómo te ',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.textPrimary,
                                ),
                              ),
                              TextSpan(
                                text: 'llamas?',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Personalizaremos tu experiencia de seguridad digital',
                          style: TextStyle(fontSize: 14, color: context.colors.textPrimary.withOpacity(0.7)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'TU NOMBRE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.colors.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    style: TextStyle(color: context.colors.textPrimary, fontSize: 16),
                    onChanged: (value) {
                      ref.read(userNameProvider.notifier).state = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Ingresa tu nombre',
                      hintStyle: TextStyle(color: context.colors.textPrimary.withOpacity(0.54)),
                      prefixIcon: Icon(
                        Icons.person,
                        color: context.colors.textPrimary.withOpacity(0.54),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.02),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.12),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: context.colors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: saveName,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: context.colors.primary,
                    ),
                    child: const Text(
                      'Siguiente →',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // Footer
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Text(
                    'Tus datos están protegidos con nosotros',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
