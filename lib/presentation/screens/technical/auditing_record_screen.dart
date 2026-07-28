import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class AuditingRecordScreen extends ConsumerWidget {
  static const name = 'auditing-record-screen';

  /// Datos del encabezado. Si no llegan, se usan los del diseño.
  final TechTaskHeader? taskHeader;

  const AuditingRecordScreen({super.key, this.taskHeader});

  static const _mockHeader = TechTaskHeader(
    client: 'Pycca',
    codeTask: '',
    location: 'Daule Matriz',
    createdBy: 'dmales',
  );

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
          taskData: taskHeader ?? _mockHeader,
          // location_id, task_id y responsible se agregan desde afuera.
          locationId: null,
          taskId: null,
          responsible: null,
          onSubmit: (data) async {
            // TODO: conectar con el repositorio cuando exista el endpoint.
            // Aquí sólo se imprime el payload ya armado.
            _debugPayload(data);

            return ApiResponse(
              success: true,
              message: 'Payload construido (aún sin envío al API)',
              data: data,
            );
          },
        ),
      ),
    );
  }

  /// Imprime el payload sin volcar los bytes de las firmas.
  void _debugPayload(Map<String, dynamic> data) {
    final preview = Map<String, dynamic>.from(data);

    for (final key in ['auditor_img', 'responsible_img', 'client_img']) {
      final bytes = preview[key];
      preview[key] = bytes is Uint8List ? '<${bytes.lengthInBytes} bytes png>' : null;
    }

    debugPrint(preview.toString());
  }
}
