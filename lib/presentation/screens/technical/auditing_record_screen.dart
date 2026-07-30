import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class AuditingRecordScreen extends ConsumerWidget {
  static const name = 'auditing-record-screen';

  /// Datos del encabezado. Si no llegan, se usan los del diseño.
  final TechTaskHeader taskHeader;

  const AuditingRecordScreen({super.key, required this.taskHeader});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderOptionsProfile(headerTxt: 'Registro fiscalización'),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: kAuditBg,
      body: SafeArea(
        top: false,
        child: AuditingRecordForm(
          taskData: taskHeader,
          // location_id, task_id y responsible se agregan desde afuera.
          locationId: taskHeader.locationId,
          taskId: taskHeader.taskId,
          responsible: taskHeader.createdBy,
          onSubmit: (data) async {
            return await ref
              .read(technicalRecordProvider.notifier)
              .saveAuditing(data);
          },
        ),
      ),
    );
  }

  /// Imprime el payload sin volcar los bytes de las firmas.
  // void _debugPayload(Map<String, dynamic> data) {
  //   final preview = Map<String, dynamic>.from(data);

  //   for (final key in ['auditor_img', 'responsible_img', 'client_img']) {
  //     final bytes = preview[key];
  //     preview[key] = bytes is Uint8List ? '<${bytes.lengthInBytes} bytes png>' : null;
  //   }

  //   debugPrint(preview.toString());
  // }
}
