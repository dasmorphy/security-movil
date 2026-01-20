import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  static const name = 'splash-screen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
    late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
     _controller = AnimationController(vsync: this);
    // Después de 4 segundos, navega a login
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        context.goNamed('login-screen');
      }
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
      // backgroundColor: const Color.fromARGB(255, 43, 41, 41),
      // backgroundColor: const Color.fromARGB(255, 36, 34, 34),
      // backgroundColor: const Color.fromARGB(190, 58, 199, 199),
      backgroundColor: const Color.fromARGB(153, 58, 199, 199),
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
