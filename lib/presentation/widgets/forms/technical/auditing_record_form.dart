import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/auditing_section.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/shared/global_loading_bottom_sheet.dart';
import 'package:zentinel/presentation/widgets/technical/auditing_colors.dart';
import 'package:zentinel/presentation/widgets/technical/auditing_item_tile.dart';
import 'package:zentinel/presentation/widgets/technical/auditing_step_indicator.dart';
import 'package:zentinel/presentation/widgets/technical/finding_card.dart';
import 'package:zentinel/presentation/widgets/technical/record_technical_header.dart';
import 'package:zentinel/presentation/widgets/technical/signature_pad.dart';

/// Formulario de fiscalización por pasos.
///
/// Las secciones vienen del provider [getAuditingSections] y se agrupan de dos
/// en dos: cada par forma un paso (Preparación, Instalación, Infraestructura,
/// Calidad) y al final se agrega el paso de Firmas.
class AuditingRecordForm extends ConsumerStatefulWidget {
  final TechTaskHeader taskData;
  final Future<ApiResponse> Function(Map<String, dynamic> data) onSubmit;

  /// Datos que se agregan desde afuera (los completa quien consume el widget).
  final int? locationId;
  final int? taskId;
  final String? responsible;

  const AuditingRecordForm({
    super.key,
    required this.taskData,
    required this.onSubmit,
    this.locationId,
    this.taskId,
    this.responsible,
  });

  @override
  ConsumerState<AuditingRecordForm> createState() => _AuditingRecordFormState();
}

class _AuditingRecordFormState extends ConsumerState<AuditingRecordForm> {
  /// Títulos de los pasos que agrupan secciones (el de Firmas se agrega aparte).
  static const _groupTitles = ['Inicio', 'Instalación', 'Redes', 'Calidad'];
  static const _signatureStepTitle = 'Firmas';

  final _formKey = GlobalKey<FormState>();
  final _scrollCtrl = ScrollController();

  bool _isInitializing = true;
  bool _isLoading = false;
  int _currentStep = 0;
  bool isPickingImage = false;

  /// idItem -> 'SI' | 'NO' | 'N/A'
  final Map<int, String> _responses = {};
  final Map<int, TextEditingController> _observationCtrls = {};
  final Map<int, FocusNode> _observationFocus = {};
  final Set<int> _itemsWithError = {};

  final List<FindingEntry> _findings = [];

  final _auditorSign = SignaturePadController();
  final _responsibleSign = SignaturePadController();
  final _clientSign = SignaturePadController();
  bool _signatureError = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(getAuditingSections.notifier).load();

      if (!mounted) return;
      setState(() => _isInitializing = false);
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    for (final ctrl in _observationCtrls.values) {
      ctrl.dispose();
    }
    for (final node in _observationFocus.values) {
      node.dispose();
    }
    for (final finding in _findings) {
      finding.dispose();
    }
    _auditorSign.dispose();
    _responsibleSign.dispose();
    _clientSign.dispose();
    super.dispose();
  }

  TextEditingController _observationCtrl(int itemId) =>
      _observationCtrls.putIfAbsent(itemId, () => TextEditingController());

  FocusNode _observationNode(int itemId) =>
      _observationFocus.putIfAbsent(itemId, () => FocusNode());

  /// Agrupa las secciones (ordenadas) en pares: dos secciones por paso.
  List<List<AuditingSection>> _groupSections(List<AuditingSection> sections) {
    final ordered = [...sections]..sort((a, b) => a.orderNumber.compareTo(b.orderNumber));
    final groups = <List<AuditingSection>>[];

    for (var i = 0; i < ordered.length; i += 2) {
      final end = (i + 2) > ordered.length ? ordered.length : i + 2;
      groups.add(ordered.sublist(i, end));
    }

    return groups;
  }

  List<String> _stepLabels(List<List<AuditingSection>> groups) => [
    for (var i = 0; i < groups.length; i++)
      i < _groupTitles.length ? _groupTitles[i] : groups[i].first.name,
    _signatureStepTitle,
  ];

  void _scrollToTop() {
    if (!_scrollCtrl.hasClients) return;
    _scrollCtrl.jumpTo(0);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: kAuditDanger,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Marca los ítems sin respuesta del grupo indicado.
  bool _validateItems(List<AuditingSection> group) {
    final missing = <int>{};

    for (final section in group) {
      for (final item in section.items) {
        if (!_responses.containsKey(item.idItem)) missing.add(item.idItem);
      }
    }

    setState(() {
      _itemsWithError
        ..clear()
        ..addAll(missing);
    });

    return missing.isEmpty;
  }

  void _goToStep(int step) {
    setState(() {
      _currentStep = step;
      _itemsWithError.clear();
    });
    _scrollToTop();
  }

  void _onPrevious() {
    FocusScope.of(context).unfocus();
    if (_currentStep == 0) {
      context.pop();
      return;
    }
    _goToStep(_currentStep - 1);
  }

  void _onNext(List<List<AuditingSection>> groups) {
    FocusScope.of(context).unfocus();

    final isSignatureStep = _currentStep >= groups.length;

    if (isSignatureStep) {
      _submit(groups);
      return;
    }

    final itemsOk = _validateItems(groups[_currentStep]);
    final findingsOk = _formKey.currentState?.validate() ?? true;

    if (!itemsOk || !findingsOk) {
      _showMessage(
        itemsOk
            ? 'Completa la descripción de los hallazgos agregados'
            : 'Responde todos los ítems para continuar',
      );
      return;
    }

    _goToStep(_currentStep + 1);
  }

  void _addFinding() {
    setState(() => _findings.add(FindingEntry(uid: const Uuid().v4(), image: [])));
  }

  void _removeFinding(int index) {
    final finding = _findings.removeAt(index);
    finding.dispose();
    setState(() {});
  }

  Future<void> _submit(List<List<AuditingSection>> groups) async {
    if (_isLoading) return;

    // Revalidar todos los pasos: si falta algo, se regresa al paso pendiente.
    for (var i = 0; i < groups.length; i++) {
      final missing = groups[i]
          .expand((section) => section.items)
          .where((item) => !_responses.containsKey(item.idItem))
          .map((item) => item.idItem)
          .toSet();

      if (missing.isNotEmpty) {
        setState(() {
          _currentStep = i;
          _itemsWithError
            ..clear()
            ..addAll(missing);
        });
        _scrollToTop();
        _showMessage('Hay ítems sin responder en el paso ${i + 1}');
        return;
      }
    }

    final signaturesComplete = _auditorSign.isNotEmpty &&
        _responsibleSign.isNotEmpty &&
        _clientSign.isNotEmpty;

    if (!signaturesComplete) {
      setState(() => _signatureError = true);
      _showMessage('Registra las 3 firmas para guardar');
      return;
    }

    final authState = ref.read(userSessionProvider);

    if (!authState.hasValue || authState.value == null) {
      _showMessage('Sesión no válida. Vuelva a iniciar sesión');
      return;
    }

    setState(() {
      _isLoading = true;
      _signatureError = false;
    });

    final auditorImg = await _auditorSign.toPngBytes();
    final responsibleImg = await _responsibleSign.toPngBytes();
    final clientImg = await _clientSign.toPngBytes();

    if (!mounted) return;

    final responses = <Map<String, dynamic>>[];

    for (final group in groups) {
      for (final section in group) {
        for (final item in section.items) {
          final observation = _observationCtrls[item.idItem]?.text.trim() ?? '';

          responses.add({
            'item_id': item.idItem,
            'response': _responses[item.idItem],
            'observation': observation.isEmpty ? 'N/A' : observation,
          });
        }
      }
    }

    final findings = _findings
        .where((finding) => !finding.isEmpty)
        // .map((finding) => finding.toJson())
        .toList();

    final findingsJson = findings.asMap().entries.map((entry) {
      final findingIndex = entry.key;
      final finding = entry.value;

      return {
        ...finding.toJson(),
        'images': List.generate(
          finding.image.length,
          (imageIndex) => 'finding_${findingIndex}_$imageIndex',
        ),
      };
    }).toList();

    final data = <String, dynamic>{
      // Firmas en bytes (Uint8List) para que el datasource decida el formato.
      "external_transaction_id": Uuid().v4(),
      'auditor_img': auditorImg,
      'responsible_img': responsibleImg,
      'client_img': clientImg,
      'finding_images': findings,
      'externalTransactionId': const Uuid().v4(),
      'data': {
        // Estos tres los completa quien consume el widget.
        'location_id': widget.locationId,
        'task_id': widget.taskId,
        'responsible': widget.responsible,
        'user': authState.value!.user,
        'responses': responses,
        'findings': findingsJson,
      },
    };

    print(findingsJson);

    GlobalLoadingBottomSheet.show(
      status: OverlayStatus.loading,
      message: 'Guardando registro...',
    );

    final response = await widget.onSubmit.call(data);

    if (!mounted) return;

    setState(() => _isLoading = false);
    GlobalLoadingBottomSheet.hide();

    if (response.success) {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.success,
        message: 'Registro guardado exitosamente',
        autoDismiss: const Duration(seconds: 2),
      );

      // if (Navigator.canPop(context)) context.pop();
    } else {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'Error: ${response.message ?? 'Error al guardar el registro'}',
        autoDismiss: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = ref.watch(getAuditingSections);

    if (_isInitializing) return const _FormLoading();

    if (sections.isEmpty) {
      return _FormEmpty(
        onRetry: () async {
          setState(() => _isInitializing = true);
          await ref.read(getAuditingSections.notifier).load();
          if (!mounted) return;
          setState(() => _isInitializing = false);
        },
      );
    }

    final groups = _groupSections(sections);
    final labels = _stepLabels(groups);
    final isSignatureStep = _currentStep >= groups.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16,6, 16, 6),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            // decoration: BoxDecoration(
            //   color: kAuditSurface,
            //   borderRadius: BorderRadius.circular(12),
            //   border: Border.all(color: kAuditBorder),
            // ),
            child: AuditingStepIndicator(
              steps: labels,
              currentStep: _currentStep,
              onStepTapped: _isLoading ? null : _goToStep,
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollCtrl,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RecordTechnicalHeader(taskData: widget.taskData),
                    const SizedBox(height: 18),
                    if (isSignatureStep)
                      ..._buildSignatureStep()
                    else
                      ..._buildSectionsStep(groups),
                    // const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _onPrevious,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    _currentStep == 0 ? 'Cancelar' : 'Atrás',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading || isPickingImage ? null : () => _onNext(groups),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: kAuditAccent,
                    disabledBackgroundColor: const Color.fromARGB(120, 7, 213, 213),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoading) ...[
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Text(
                        isSignatureStep ? 'Guardar' : 'Siguiente',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSectionsStep(List<List<AuditingSection>> groups) {
    final group = groups[_currentStep];
    final isQualityStep = _currentStep == groups.length - 1;

    return [
      for (final section in group) ...[
        _SectionTitle(title: section.name, itemsCount: section.items.length),
        const SizedBox(height: 12),
        for (final item in ([...section.items]
          ..sort((a, b) => a.orderNumber.compareTo(b.orderNumber))))
          AuditingItemTile(
            key: ValueKey('item-${item.idItem}'),
            label: item.name,
            value: _responses[item.idItem],
            hasError: _itemsWithError.contains(item.idItem),
            observationController: _observationCtrl(item.idItem),
            observationFocus: _observationNode(item.idItem),
            onChanged: (value) {
              setState(() {
                _responses[item.idItem] = value;
                _itemsWithError.remove(item.idItem);
              });
            },
          ),
        const SizedBox(height: 8),
      ],
      if (isQualityStep) ..._buildFindings(),
    ];
  }

  List<Widget> _buildFindings() {
    return [
      const SizedBox(height: 4),
      Row(
        children: [
          const Expanded(
            child: Text(
              'Hallazgos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: _addFinding,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: kAuditAccent.withValues(alpha: 0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.add_rounded, size: 18, color: kAuditAccentSoft),
            label: const Text(
              'Agregar',
              style: TextStyle(
                color: kAuditAccentSoft,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      if (_findings.isEmpty)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
          decoration: BoxDecoration(
            color: kAuditField,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kAuditBorder),
          ),
          child: const Text(
            'Sin hallazgos registrados. Usa "Agregar" si encontraste alguna novedad.',
            textAlign: TextAlign.center,
            style: TextStyle(color: kAuditTextMuted, fontSize: 13),
          ),
        )
      else
        for (var i = 0; i < _findings.length; i++)
          FindingCard(
            key: ValueKey(_findings[i].uid),
            finding: _findings[i],
            position: i + 1,
            onRemove: () => _removeFinding(i),
            onPickingChanged: (value) {
              setState(() {
                isPickingImage = value;
              });
            },
            isPickingImage: isPickingImage,
            onImagesChanged: (images) {
              print(images);
              _findings[i].image = images
                .whereType<Uint8List>()
                .toList();
            },
            imagesMaxError: _findings[i].image.length > 2
          ),
    ];
  }

  List<Widget> _buildSignatureStep() {
    return [
      const _SectionTitle(title: 'Firmas', subtitle: 'Dibuja cada firma con el dedo'),
      const SizedBox(height: 14),
      SignaturePad(
        label: 'Auditor',
        controller: _auditorSign,
        hasError: _signatureError,
      ),
      const SizedBox(height: 18),
      SignaturePad(
        label: 'Responsable técnico',
        controller: _responsibleSign,
        hasError: _signatureError,
      ),
      const SizedBox(height: 18),
      SignaturePad(
        label: 'Cliente',
        controller: _clientSign,
        hasError: _signatureError,
      ),
    ];
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int? itemsCount;

  const _SectionTitle({required this.title, this.subtitle, this.itemsCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 3,
          height: subtitle == null ? 18 : 32,
          margin: const EdgeInsets.only(top: 2, right: 10),
          decoration: BoxDecoration(
            color: kAuditAccent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(color: kAuditTextMuted, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        if (itemsCount != null)
          Text(
            '$itemsCount ítems',
            style: const TextStyle(color: kAuditTextMuted, fontSize: 11),
          ),
      ],
    );
  }
}

class _FormLoading extends StatelessWidget {
  const _FormLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Cargando formulario...',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          ),
        ],
      ),
    );
  }
}

class _FormEmpty extends StatelessWidget {
  final Future<void> Function() onRetry;

  const _FormEmpty({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assignment_late_outlined, color: kAuditTextMuted, size: 40),
            const SizedBox(height: 12),
            const Text(
              'No se pudieron cargar las secciones de fiscalización.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: kAuditAccent,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Reintentar',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
