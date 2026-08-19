import 'package:flutter/material.dart';
import 'package:zentinel/domain/entities/technical_record.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewTaskScreen extends ConsumerStatefulWidget  {
  static const name = 'new-task-screen';
  final TechTaskHeader taskHeader;
  final TechnicalRecord? dataRegisterIcompleted;


  
  const NewTaskScreen({super.key, required this.taskHeader, this.dataRegisterIcompleted});

  @override
  ConsumerState<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends ConsumerState<NewTaskScreen> {
  @override
  void initState() {
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderOptionsProfile(headerTxt: "Registro técnico",),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        // bottom: false,
        child: 
          TechnicalRecordForm(
            taskIncompleted: widget.dataRegisterIcompleted,
            taskData: widget.taskHeader,
            onSubmit: (data) async {
              return await ref
                .read(technicalRecordProvider.notifier)
                .saveTechnicalRecord(data);
            },
          ),
            
      ),
    );
  }
}
