import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class CheckSuccessScreen extends ConsumerStatefulWidget {
  static const name = 'check-success-screen';
  const CheckSuccessScreen({super.key});

  @override
  ConsumerState<CheckSuccessScreen> createState() => _CheckSuccessScreenState();
}

class _CheckSuccessScreenState extends ConsumerState<CheckSuccessScreen> {
  
  bool _showButton = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showButton = true;
        });
      }
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'lib/assets/lottie/success_check.json',
            width: 240,
            height: 240,
            fit: BoxFit.fill,
            repeat: false,
          ),

          Text(
            '¡Proceso con éxito!',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w600,
            ) ?? const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 70),

          if (_showButton)
            FadeInUpBig(
              duration: const Duration(milliseconds: 1000),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 63, 81, 181),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Aceptar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
