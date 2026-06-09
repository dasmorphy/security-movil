import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewEmployeeMovementScreen extends ConsumerStatefulWidget  {

  static const name = 'new-employee-movement-screen';

  final String typeMovement;
  
  const NewEmployeeMovementScreen({super.key, required this.typeMovement});

  @override
  ConsumerState<NewEmployeeMovementScreen> createState() => _NewEmployeeMovementScreenState();
}

class _NewEmployeeMovementScreenState extends ConsumerState<NewEmployeeMovementScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    ref.read(getHistoryEntryAccess.notifier).load();
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
            onSubmit: (data) async {
              return await ref
                .read(saveEmployeeInternProvider.notifier)
                .saveEmployeeMovement(data);
            },
          ),
            
      ),
    );
  }
}
