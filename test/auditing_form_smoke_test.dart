import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zentinel/domain/datasources/technical_datasource.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/auditing_section.dart';
import 'package:zentinel/domain/entities/client_technical.dart';
import 'package:zentinel/domain/entities/location_technical.dart';
import 'package:zentinel/domain/entities/task_technical.dart';
import 'package:zentinel/domain/entities/tech_material.dart';
import 'package:zentinel/domain/entities/technical_staff.dart';
import 'package:zentinel/infraestructure/repositories/technical_repository_impl.dart';
import 'package:zentinel/presentation/providers/technical/technical_repository_provider.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

AuditingSection _section(int id, String name, int order, List<String> items) {
  return AuditingSection(
    createdAt: DateTime(2026, 7, 8),
    createdBy: 'dmales',
    idSection: id,
    name: name,
    orderNumber: order,
    items: [
      for (var i = 0; i < items.length; i++)
        Item(
          createdAt: DateTime(2026, 7, 8),
          createdBy: 'dmales',
          idItem: id * 100 + i,
          name: items[i],
          orderNumber: i + 1,
        ),
    ],
  );
}

final _sections = [
  _section(1, 'Documentación', 1, ['Planos aprobados', 'Cronograma', 'Permisos', 'ATS', 'Manuales']),
  _section(2, 'Seguridad Industrial', 2, ['EPP completo', 'Área delimitada', 'Orden y limpieza', 'Escaleras certificadas']),
  _section(3, 'CCTV', 3, ['Ubicación según plano', 'Imagen correcta', 'Etiquetado', 'Grabación OK']),
  _section(4, 'Control de Acceso', 4, ['Lectores', 'Botón salida', 'Cerradura', 'Pruebas funcionales']),
  _section(5, 'Cableado', 5, ['Canalización', 'Etiquetado', 'Organización', 'Sin empalmes']),
  _section(6, 'Rack y Redes', 6, ['Rack ordenado', 'Patch panel', 'Switch', 'UPS', 'Conectividad']),
  _section(7, 'Calidad', 7, ['Acabados', 'Limpieza', 'Documentación entregada']),
];

class _FakeDatasource extends TechnicalDatasource {
  @override
  Future<List<AuditingSection>> getAuditingSection() async => _sections;

  @override
  Future<List<TaskTechnical>> getTaskTechnical() => throw UnimplementedError();

  @override
  Future<List<TechMaterial>> getTechMeterial() => throw UnimplementedError();

  @override
   Future<ApiResponse> saveTechnicalRecord(Map<String, dynamic> data) => throw UnimplementedError();

  @override
  Future<ApiResponse<dynamic>> saveAuditing(Map<String, dynamic> data) => throw UnimplementedError();

  @override
  Future<List<ClientTechnical>> getClientsTechnical() {
    // TODO: implement getClientsTechnical
    throw UnimplementedError();
  }

  @override
  Future<List<LocationTechnical>> getLocationTechnical(Map<String, dynamic> filters) {
    // TODO: implement getLocationTechnical
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<dynamic>> saveProjectTechnical(Map<String, dynamic> data) {
    // TODO: implement saveProjectTechnical
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<dynamic>> updateStatusProject(Map<String, dynamic> data) {
    // TODO: implement updateStatusProject
    throw UnimplementedError();
  }

  @override
  Future<List<TechnicalStaff>> getTechnicalStaff() {
    // TODO: implement getTechnicalStaff
    throw UnimplementedError();
  }  
}

void main() {
  testWidgets('recorre los 5 pasos y valida firmas', (tester) async {
    tester.view.physicalSize = const Size(1080, 2100);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          technicalRepositoryProvider.overrideWith(
            (ref) => TechnicalRepositoryImpl(_FakeDatasource()),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            backgroundColor: kAuditBg,
            body: AuditingRecordForm(
              locationId: 1,
              responsible: 'kj',
              taskId: 1,
              taskData: const TechTaskHeader(
                cliendId: 1,
                locationId: 1,
                taskId: 1,
                client: 'Pycca',
                codeTask: '',
                location: 'Daule Matriz',
                createdBy: 'dmales',
              ),
              onSubmit: (data) async => ApiResponse(success: true),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Stepper con los 5 pasos
    for (final label in ['Preparación', 'Instalación', 'Infraestructura', 'Calidad', 'Firmas']) {
      expect(find.text(label), findsWidgets, reason: 'falta el paso $label');
    }

    // Paso 1: dos secciones
    expect(find.text('DOCUMENTACIÓN'), findsOneWidget);
    expect(find.text('SEGURIDAD INDUSTRIAL'), findsOneWidget);
    expect(find.text('Planos aprobados'), findsOneWidget);

    // No avanza sin responder
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();
    expect(find.text('Responde todos los ítems para continuar'), findsOneWidget);
    expect(find.text('DOCUMENTACIÓN'), findsOneWidget);

    // Responder los 4 pasos con secciones
    for (var step = 0; step < 4; step++) {
      final total = tester.widgetList(find.text('Si')).length;
      expect(total, greaterThan(0));

      for (var i = 0; i < total; i++) {
        final option = find.text('Si').at(i);
        await tester.ensureVisible(option);
        await tester.pumpAndSettle();
        await tester.tap(option);
        await tester.pump();
      }

      if (step == 3) {
        // El paso de Calidad incluye Hallazgos
        expect(find.text('Hallazgos'), findsOneWidget);
        await tester.ensureVisible(find.text('Agregar'));
        await tester.tap(find.text('Agregar'));
        await tester.pumpAndSettle();
        expect(find.text('Hallazgo 1'), findsOneWidget);
        expect(find.text('CRITICIDAD'), findsOneWidget);
        expect(find.text('COMPROMISO'), findsOneWidget);
      }

      await tester.ensureVisible(find.text('Siguiente'));
      await tester.tap(find.text('Siguiente'));
      await tester.pumpAndSettle();
    }

    // Paso 4 bloquea si el hallazgo no tiene descripción
    expect(find.text('La descripción es obligatoria'), findsOneWidget);
    await tester.enterText(
      find
          .descendant(
            of: find.byType(FindingCard),
            matching: find.byType(TextFormField),
          )
          .first,
      'Rayón en canaleta del pasillo 3',
    );
    // Dejar que el SnackBar se cierre para no tapar el botón
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Siguiente'));
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();

    // Paso 5: firmas
    expect(find.text('Guardar'), findsOneWidget);
    expect(find.text('AUDITOR'), findsOneWidget);
    expect(find.text('RESPONSABLE TÉCNICO'), findsOneWidget);
    // 'CLIENTE' también es la etiqueta del encabezado
    expect(find.text('CLIENTE'), findsNWidgets(2));
    expect(find.byType(SignaturePad), findsNWidgets(3));

    // Dibujar en el primer pad: debe aparecer "Limpiar"
    final pad = find.byType(SignaturePad).first;
    await tester.ensureVisible(pad);
    await tester.pumpAndSettle();
    await tester.drag(pad, const Offset(40, 25));
    await tester.pumpAndSettle();
    expect(find.text('Limpiar'), findsOneWidget);

    // No guarda con firmas incompletas
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Registra las 3 firmas para guardar'), findsOneWidget);
  });

  testWidgets('la firma se exporta a PNG', (tester) async {
    final controller = SignaturePadController();
    expect(controller.isEmpty, isTrue);

    controller.updateCanvasSize(const Size(300, 150));
    controller.startStroke(const Offset(10, 20));
    controller.addPoint(const Offset(80, 90));
    controller.addPoint(const Offset(140, 40));

    // toImage() necesita el event loop real, por eso runAsync.
    final bytes = await tester.runAsync(() => controller.toPngBytes());

    expect(bytes, isNotNull);
    // Firma del formato PNG
    expect(bytes!.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);

    controller.clear();
    expect(controller.isEmpty, isTrue);
    expect(await tester.runAsync(() => controller.toPngBytes()), isNull);
  });
}
