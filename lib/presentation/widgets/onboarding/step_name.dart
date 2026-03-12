import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/presentation/providers/onboarding/onboarding_provider.dart';

class StepName extends ConsumerStatefulWidget {
  final VoidCallback nextPage;

  const StepName({super.key, required this.nextPage});

  @override
  ConsumerState<StepName> createState() => _StepNameState();
}

class _StepNameState extends ConsumerState<StepName> {
  final TextEditingController controller = TextEditingController();

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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '¿Cómo te llamas?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Esto nos ayudará a personalizar tu experiencia',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Ingresa tu nombre',
                hintStyle: const TextStyle(color: Colors.white54),
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
                    color: const Color.fromARGB(189, 7, 213, 213),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: saveName,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: const Color.fromARGB(189, 7, 213, 213),
              ),
              child: const Text(
                'Siguiente',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
