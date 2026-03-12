import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/presentation/providers/auth/auth_provider.dart';
import 'package:zentinel/presentation/providers/onboarding/onboarding_provider.dart';
import 'package:zentinel/presentation/screens/home_screen.dart';
import 'package:zentinel/presentation/screens/login_screen.dart';
import 'package:zentinel/presentation/screens/onboarding/onboarding_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const name = 'splash-screen';

  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    
    // Después de 2 segundos, validar sesión y navegar
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      // Validar si hay sesión persistida
      final authState = ref.read(userSessionProvider);
      authState.maybeWhen(
        data: (user) {
          if (user != null) {
            // Hay sesión, validar si tiene perfil de onboarding
            final hiveService = ref.read(hiveServiceProvider);
            final hasProfile = hiveService.hasUserProfile(user.email);
            
            if (hasProfile) {
              context.goNamed(HomeScreen.name);
            } else {
              context.goNamed(OnboardingScreen.name);
            }
          } else {
            // No hay sesión, ir a login
            context.goNamed(LoginScreen.name);
          }
        },
        orElse: () {
          // Error o loading, ir a login
          context.goNamed(LoginScreen.name);
        },
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 8, 15),
      body: Center(
        child: Container(
          child: Lottie.asset(
            'lib/assets/lottie/zentinel.json',
          ),
        ),
      ),
    );
  }
}
