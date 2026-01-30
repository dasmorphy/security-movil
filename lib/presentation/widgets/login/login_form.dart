import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/presentation/providers/auth/auth_provider.dart';

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
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
              'Ingrese un usuario y contraseña válidos.', 
            style: TextStyle(
              color: Color.fromARGB(255, 162, 15, 15), 
              fontSize: 14,
              fontWeight: FontWeight.bold
            )),
        ),

        const SizedBox(height: 30),
        

        // Login button
        ElevatedButton(
          onPressed: () {
            validateUser(context, _passwordController.text, _emailController.text, ref);
            // context.go('/');
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: Color.fromARGB(189, 7, 213, 213),
          ),
          child: const Text(
            'Iniciar sesión', 
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), 
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

void validateUser(BuildContext context, String password, String email, WidgetRef ref) {
  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ingrese un usuario y contraseña válidos.'),
        backgroundColor: Color.fromARGB(255, 212, 219, 19),
        duration: Duration(seconds: 3),
      ),
    );
  }
  else if (email == 'admin' && password == '123456') {
    final dataUser = {
      'email': email,
      'name': 'Administrador',
      'user': email,
      'role': 'admin',
      'business': 'Expalsa'
    };
    ref.read(authProvider.notifier).authUser(dataUser);
    context.go('/');
  } else if (email == 'dmales@hotmail.com' && password == '123456') {
    final dataUser = {
      'email': email,
      'name': 'Daniel Males',
      'user': email,
      'group_business': 1,
      'name_group_business': 'Camanglar 1',
      'role': 'guardia',
    };
    ref.read(authProvider.notifier).authUser(dataUser);
    context.go('/');
  } else if (email == 'dcedeno@hotmail.com' && password == '123456') {
    final dataUser = {
      'email': email,
      'user': email,
      'name': 'David Cedeño',
      'group_business': 2,
      'name_group_business': 'Camanglar 2',
      'role': 'guardia',
    };
    ref.read(authProvider.notifier).authUser(dataUser);
    context.go('/');
  } else if (email == 'dvillamar@hotmail.com' && password == '123456') {
    final dataUser = {
      'email': email,
      'user': email,
      'name': 'David Villamar',
      'group_business': 3,
      'name_group_business': 'Camanglar 3',
      'role': 'guardia',
    };
    ref.read(authProvider.notifier).authUser(dataUser);
    context.go('/');
  }else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuario o contraseña incorrectos.'),
        backgroundColor: Color.fromARGB(255, 212, 19, 19),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
