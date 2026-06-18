import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewAttendanceScreen extends ConsumerStatefulWidget  {

  static const name = 'new-attendance-screen';

  final dynamic isProductTerm;
  
  const NewAttendanceScreen({super.key, this.isProductTerm = false});

  @override
  ConsumerState<NewAttendanceScreen> createState() => _NewAttendanceScreenState();
}

class _NewAttendanceScreenState extends ConsumerState<NewAttendanceScreen> {
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
        child: HeaderOptionsProfile(headerTxt: "Asistencia",),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        // bottom: false,
        child: 
          AttendanceOmarsaForm(
            onSubmit: (data) async {
              return await ref
                .read(dispatchProvider.notifier)
                .saveDispatch(data);
            },
          ),
            
      ),
    );
  }
}
