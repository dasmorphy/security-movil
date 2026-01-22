import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const name = 'login-screen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 14, 170, 170),
            Color.fromARGB(255, 5, 7, 7),
          ],
          stops: [0.1, 0.4],
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        // No appBar here: login_screen should not show the global header
        body: SafeArea(
          // top: true,
          // bottom: false,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [Color.fromARGB(4, 148, 0, 0), Color.fromARGB(0, 105, 88, 19)],
              //   stops: [0.8,1.0],
              // ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        'lib/assets/images/zentinel-logo.png',
                        width: 200,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Centered, scrollable card
                  Positioned.fill(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        top: 120,
                        bottom: 100,
                        left: 20,
                        right: 20,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: size.width < 600 ? size.width : 520,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
                                decoration: BoxDecoration(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 28,
                                ),
                                child: Column(
                                  
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 6),
                                    const _GlassCard(
                                      height: 500,
                                      width: 650,
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            _Header(),
                                            SizedBox(height: 18),
                                            LoginForm(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // const _Header(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Fixed footer powered image
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        'lib/assets/images/powered.png',
                        width: 150,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: Text(
            'Bienvenido/a',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: Text(
            'Iniciar sesión',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  const _GlassCard({required this.child, this.height = 200, this.width = 350});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: height,
      width: width,
      gradient: LinearGradient(
        colors: [
          const Color.fromARGB(255, 255, 255, 255).withValues(alpha: 0.3),
          const Color.fromARGB(255, 7, 137, 92).withValues(alpha: 0.1),
          Colors.white.withValues(alpha: 0.07),
          // Colors.white.withValues(alpha: 0.07), 
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.05, 0.2, 0.4]
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.80),
          Colors.white.withValues(alpha: 0.10),
          const Color.fromARGB(158, 2, 79, 58).withValues(alpha: 0.05),
          const Color.fromARGB(255, 40, 41, 40).withValues(alpha: 0.60),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.80, 0.40, 1.0],
      ),
      blur: 20,
      borderRadius: BorderRadius.circular(24.0),
      borderWidth: 1.0,
      elevation: 3.0,
      // isFrostedGlass: true,
      shadowColor: Colors.purple.withValues(alpha: 0.20),
      child: child,
    );
  }
}
