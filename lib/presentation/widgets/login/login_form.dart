import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.02),
      hintStyle: const TextStyle(color: Colors.white70),
      labelStyle: const TextStyle(color: Colors.white70),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

      // Borde normal
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.12),
          width: 1,
        ),
      ),

      // Borde cuando está enfocado
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.12),
          width: 1,
        ),
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14
          ),
          decoration: inputDecoration.copyWith(
            hintText: 'Correo electrónico',
          ),
        ),

        const SizedBox(height: 12),

        // Password field (kept minimal since design focuses email-first)
        TextField(
          controller: _passwordController,
          obscureText: true,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14
          ),
          decoration: inputDecoration.copyWith(
            hintText: 'Contraseña',
            // prefixIcon: const Icon(Icons.lock, color: Colors.white70),
          ),
        ),

        const SizedBox(height: 30),
        

        // Login button
        ElevatedButton(
          onPressed: () => context.go('/home'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: Color.fromARGB(190, 58, 199, 199),
          ),
          child: const Text(
            'Iniciar sesión', 
            style: TextStyle(
              color: Colors.white, 
              fontSize: 16,
              fontWeight: FontWeight.bold
            )),
        ),
        
        
        const SizedBox(height: 18),
      
        // Sign up link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("¿No tienes una cuenta?", style: TextStyle(color: Colors.white54)),
            TextButton(
              onPressed: () {},
              child: const Text('Registrarse', style: TextStyle(color: Color.fromARGB(255, 14, 170, 170))),
            )
          ],
        ),
      ],
    );
  }
}
