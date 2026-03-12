import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class PersonalDataScreen extends StatelessWidget {

  static const name = 'personal-data-screen';

  const PersonalDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Datos personales',),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        // bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PersonalDataItem(
                icon: Icons.key,
                title: 'Correo electrónico',
                subTitle: 'daxxxx@xxxx',
                onTap: () {
                  context.push('/change-email');
                },
              ),
              const SizedBox(height: 17,),
              PersonalDataItem(
                icon: Icons.phone_android_rounded,
                title: 'Celular',
                subTitle: '09xxxxx67',
                onTap: () {},
              ),
              const SizedBox(height: 17,),
              PersonalDataItem(
                icon: Icons.key,
                title: 'Contraseña',
                subTitle: 'Cambia tu contraseña en cualquier momento',
                onTap: () {},
              )
            ], //Widget para conservar el estado de la pagina (ej Si hace scroll dejarlo tal cual)
          ),
        ),
      ),
    );
  }
}