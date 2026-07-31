import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewProyectTechnicalScreen extends ConsumerStatefulWidget  {
  static const name = 'new-proyect-technical-screen';

  const NewProyectTechnicalScreen({super.key});

  @override
  ConsumerState<NewProyectTechnicalScreen> createState() => _NewProyectTechnicalScreenState();
}

class _NewProyectTechnicalScreenState extends ConsumerState<NewProyectTechnicalScreen> {
  @override
  void initState() {
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderOptionsProfile(headerTxt: "Registro de proyecto",),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        // bottom: false,
        child: 
          NewProjectTechnical(
            onSubmit: (data) async {
              return await ref
                .read(technicalRecordProvider.notifier)
                .saveProjectTechnical(data);
            },
          ),
            
      ),
    );
  }
}
