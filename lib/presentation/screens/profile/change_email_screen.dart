import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ChangeEmailScreen extends StatelessWidget {
  static const name = 'change-email-screen';

  const ChangeEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Nuevo correo electrónico',),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.colors.card,
      body: SafeArea(
        top: false,
        // bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ChangeEmailForm(),
        ),
      ),
    );
  }
}
