import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
// import 'package:zentinel/presentation/providers/logbook/logbook_provider.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

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
    // final tabHome = ref.watch(homeTabProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Nuevo correo electrónico',),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: Column(
        children: [
          Lottie.asset(
            'lib/assets/lottie/success_check.json',
          
          ),

          const SizedBox(height: 40),

          if (_showButton)
            FadeIn(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Aceptar'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
