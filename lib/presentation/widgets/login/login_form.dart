import 'package:flutter/material.dart';

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
            // prefixIcon: const Icon(Icons.email, color: Colors.white70),
            // suffixIcon: Padding(
            //   padding: const EdgeInsets.only(right: 6),
            //   child: GestureDetector(
            //     onTap: () {},
            //     child: Container(
            //       width: 44,
            //       height: 44,
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         gradient: LinearGradient(colors: [Colors.greenAccent.shade400, Colors.tealAccent.shade200]),
            //         boxShadow: [BoxShadow(color: Colors.greenAccent.withOpacity(0.16), blurRadius: 8, offset: const Offset(0, 4))],
            //       ),
            //       child: const Icon(Icons.arrow_forward, color: Colors.black87),
            //     ),
            //   ),
            // ),
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

        const SizedBox(height: 18),

        // OR divider
        Row(
          children: const [
            Expanded(child: Divider(color: Colors.white24, thickness: 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('O', style: TextStyle(color: Colors.white54)),
            ),
            Expanded(child: Divider(color: Colors.white24, thickness: 1)),
          ],
        ),

        const SizedBox(height: 18),

        // Social button: Google (placeholder icon with 'G')
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 48, 44, 44).withOpacity(0.5),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(0.06),
                child: const Text('G', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              const Expanded(child: Text('Continuar con Google', style: TextStyle(color: Colors.white70))),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_forward, color: Colors.white70, size: 18),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Social button: X (placeholder)
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 48, 44, 44).withOpacity(0.5),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(0.06),
                child: const Text('X', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              const Expanded(child: Text('Continuar con X', style: TextStyle(color: Colors.white70))),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_forward, color: Colors.white70, size: 18),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Sign up link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("¿No tienes una cuenta?", style: TextStyle(color: Colors.white54)),
            TextButton(
              onPressed: () {},
              child: const Text('Registrarse', style: TextStyle(color: Colors.greenAccent)),
            )
          ],
        ),
      ],
    );
  }
}
