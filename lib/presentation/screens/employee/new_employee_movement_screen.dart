import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeMovementArgs {
  final int idEmployee;
  final String typeMovement;

  EmployeeMovementArgs({
    required this.idEmployee,
    required this.typeMovement,
  });
}

class NewEmployeeMovementScreen extends ConsumerStatefulWidget  {

  static const name = 'new-employee-movement-screen';

  final String typeMovement;
  final int idEmployee;
  
  const NewEmployeeMovementScreen({super.key, required this.typeMovement, required this.idEmployee});

  @override
  ConsumerState<NewEmployeeMovementScreen> createState() => _NewEmployeeMovementScreenState();
}

class _NewEmployeeMovementScreenState extends ConsumerState<NewEmployeeMovementScreen> {
  @override
  void initState() {
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderOptionsProfile(headerTxt: "Registro movimiento",),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        // bottom: false,
        child: 
          EmployeeMovementForm(
            typeMovement: widget.typeMovement,
            idEmployee: widget.idEmployee,
            onSubmit: (data) async {
              return await ref
                .read(postApiResponseProvider.notifier)
                .saveEmployeeMovement(data);
            },
          ),
            
      ),
    );
  }
}
