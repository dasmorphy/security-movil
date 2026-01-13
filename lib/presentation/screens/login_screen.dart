import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/shared/custom_appbar.dart';
import 'package:zentinel/presentation/widgets/login/login_form.dart';

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
          stops: [0.1,0.4]
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: const CustomAppbar(),
        ),
        body: SafeArea(
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
                  top: 50,
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
                    padding: const EdgeInsets.only(top: 120, bottom: 100, left: 20, right: 20),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: size.width < 600 ? size.width : 520),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              decoration: BoxDecoration(),
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 6),
                                  const _Header(),
                                  const SizedBox(height: 18),
                                  const LoginForm(),
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
      )),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        // const SizedBox(height: 60),
        Text(
          'Bienvenido/a', 
          textAlign: TextAlign.center, 
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w900
          )
        ),
          // style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
        const SizedBox(height: 15),
        Text('Iniciar sesión', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
      ],
    );
  }
}
