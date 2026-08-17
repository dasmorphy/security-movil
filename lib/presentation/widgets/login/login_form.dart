import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/domain/entities/user_session.dart';
import 'package:zentinel/presentation/providers/auth/auth_provider.dart';
import 'package:zentinel/presentation/providers/onboarding/onboarding_provider.dart';
import 'package:zentinel/presentation/providers/providers.dart';

class LoginForm extends ConsumerStatefulWidget {
  final String? Function(Map<String, dynamic>? data)? onTap;

  const LoginForm({super.key, this.onTap});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<User?>>(userSessionProvider, (prev, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            final hiveService = ref.read(hiveServiceProvider);
            final hasProfile = hiveService.hasUserProfile(user.email);
            
            if (!hasProfile) {
              // Limpiar nombre anterior antes de ir al onboarding
              ref.read(userNameProvider.notifier).state = '';
              context.go('/onboarding');
            } else {
              context.go('/');
            }
          }
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: const Color.fromARGB(255, 219, 66, 19),
            ),
          );
        },
      );
    });

    final authState = ref.watch(userSessionProvider);
    final isLoading = authState.isLoading;

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.02),
      hintStyle: const TextStyle(color: Colors.white70),
      labelStyle: const TextStyle(color: Colors.white70),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

      // Borde normal
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.12), width: 1),
      ),

      // Borde cuando está enfocado
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.12), width: 1),
      ),

      // Quita el border por defecto
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email field with circular arrow button
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: inputDecoration.copyWith(hintText: 'Correo electrónico'),
        ),

        const SizedBox(height: 12),

        // Password field (kept minimal since design focuses email-first)
        TextField(
          controller: _passwordController,
          obscureText: true,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: inputDecoration.copyWith(
            hintText: 'Contraseña',
            // prefixIcon: const Icon(Icons.lock, color: Colors.white70),
          ),
        ),

        const SizedBox(height: 30),

        // Login button
        ElevatedButton(
          onPressed: isLoading
            ? null
            : () {
                FocusScope.of(context).unfocus(); //cerrar teclado
                validateUser(
                  context,
                  _passwordController.text,
                  _emailController.text,
                  ref,
                );
              },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: const Color.fromARGB(189, 7, 213, 213),
            disabledBackgroundColor: const Color.fromARGB(120, 7, 213, 213),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              const Text(
                'Iniciar sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Sign up link
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     const Text(
        //       "¿No tienes una cuenta?",
        //       style: TextStyle(color: Colors.white54),
        //     ),
        //     TextButton(
        //       onPressed: () {},
        //       child: const Text(
        //         'Registrarse',
        //         style: TextStyle(color: Color.fromARGB(255, 14, 170, 170)),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

void validateUser(
  BuildContext context,
  String password,
  String email,
  WidgetRef ref,
) async {
  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ingrese un usuario y contraseña válidos.'),
        backgroundColor: Color.fromARGB(255, 219, 66, 19),
        duration: Duration(seconds: 3),
      ),
    );
    return;
  }
  final fcmToken = await PushNotificationProvider.instance.resolveFcmToken();

  if (fcmToken == null || fcmToken.isEmpty) {
    print('Sin token FCM disponible, no se registra en el backend');
    return;
  }

  ref.read(userSessionProvider.notifier).signin({
    "user": email,
    "password": password,
    "fcm_token": fcmToken,
    "platform": PushNotificationProvider.instance.platform,
    "project_id": 1
  });
}
