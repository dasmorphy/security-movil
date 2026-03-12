import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/presentation/providers/onboarding/onboarding_provider.dart';

class StepPhoto extends ConsumerStatefulWidget {
  const StepPhoto({super.key});

  @override
  ConsumerState<StepPhoto> createState() => _StepPhotoState();
}

class _StepPhotoState extends ConsumerState<StepPhoto> {
  File? photo;
  bool _isLoading = false;

  Future<void> takePhoto() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final file = File(image.path);

      setState(() {
        photo = file;
      });
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
      await ref.read(onboardingProvider.notifier).saveUserProfile(
        photoPath: photo!.path,
      );

      // Pequeño delay para asegurar que Hive persista los datos
      await Future.delayed(const Duration(milliseconds: 500));

      // Invalidar el provider para que se refresque con los nuevos datos
      ref.invalidate(userProfileProvider);

      if (mounted) {
        context.go('/');
      }
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
              'Tu foto de perfil',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Captura una foto clara desde tu cámara',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Center(
              child: photo != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        photo!,
                        width: 220,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 80,
                        color: Colors.white54,
                      ),
                    ),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Capturar foto', style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: const Color.fromARGB(189, 7, 213, 213),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : finish,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.green.withOpacity(0.7),
                disabledBackgroundColor: Colors.green.withOpacity(0.4),
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
                      'Completar',
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
