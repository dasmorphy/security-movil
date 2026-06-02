import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewEmployeeScreen extends ConsumerStatefulWidget  {

  static const name = 'new-employee-screen';

  final dynamic isProductTerm;
  
  const NewEmployeeScreen({super.key, this.isProductTerm = false});

  @override
  ConsumerState<NewEmployeeScreen> createState() => _NewEmployeeScreenState();
}

class _NewEmployeeScreenState extends ConsumerState<NewEmployeeScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    ref.read(getHistoryEntryAccess.notifier).load();
  }
  

  @override
  Widget build(BuildContext context) {
    final String title = widget.isProductTerm == true ? 'Producto terminado' : 'Nuevo despacho'; 
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderOptionsProfile(headerTxt: title,),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        // bottom: false,
        child: 
              EmployeeInternForm(
                onSubmit: (data) async {
                  return await ref
                    .read(saveEmployeeInternProvider.notifier)
                    .saveEmployeeIntern(data);
                },
              ),
            
      ),
    );
  }
}
