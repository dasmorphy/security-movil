import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

/// Controladores de un hallazgo. Vive en el estado del formulario para que los
/// textos no se pierdan al cambiar de paso.
class FindingEntry {
  final String uid;
  final TextEditingController description = TextEditingController();
  final TextEditingController criticality = TextEditingController();
  final TextEditingController responsible = TextEditingController();
  final TextEditingController commitment = TextEditingController();
  late List<Uint8List> image = [];

  final FocusNode descriptionFocus = FocusNode();
  final FocusNode criticalityFocus = FocusNode();
  final FocusNode responsibleFocus = FocusNode();
  final FocusNode commitmentFocus = FocusNode();

  FindingEntry({required this.uid, required this.image});

  bool get isEmpty =>
      description.text.trim().isEmpty &&
      criticality.text.trim().isEmpty &&
      responsible.text.trim().isEmpty &&
      commitment.text.trim().isEmpty;

  Map<String, dynamic> toJson() => {
    'description': description.text.trim(),
    'criticality': criticality.text.trim(),
    'responsible': responsible.text.trim(),
    'commitment': commitment.text.trim(),
    'images': image.whereType<Uint8List>().toList(),
  };

  void dispose() {
    description.dispose();
    criticality.dispose();
    responsible.dispose();
    commitment.dispose();
    descriptionFocus.dispose();
    criticalityFocus.dispose();
    responsibleFocus.dispose();
    commitmentFocus.dispose();
  }
}

/// Tarjeta de un hallazgo dentro del paso de Calidad.
class FindingCard extends StatelessWidget {
  final FindingEntry finding;
  final int position;
  final VoidCallback onRemove;
  final ValueChanged<bool>? onPickingChanged;
  final Function(List<Uint8List>) onImagesChanged;
  final bool imagesMaxError;
  final bool isPickingImage;

  const FindingCard({
    super.key,
    required this.finding,
    required this.position,
    required this.onRemove,
    required this.onPickingChanged,
    required this.onImagesChanged,
    required this.imagesMaxError,
    required this.isPickingImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: BoxDecoration(
        color: kAuditSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kAuditBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: kAuditAccent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Hallazgo $position',
                  style: const TextStyle(
                    color: kAuditAccentSoft,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onRemove,
                visualDensity: VisualDensity.compact,
                tooltip: 'Eliminar hallazgo',
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: kAuditDanger,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _FindingField(
            label: 'Descripción',
            controller: finding.description,
            focusNode: finding.descriptionFocus,
            hint: 'Describe el hallazgo...',
            maxLines: 3,
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'La descripción es obligatoria'
                : null,
          ),
          _FindingField(
            label: 'Criticidad',
            controller: finding.criticality,
            focusNode: finding.criticalityFocus,
            hint: 'Alta / Media / Baja',
          ),
          _FindingField(
            label: 'Responsable',
            controller: finding.responsible,
            focusNode: finding.responsibleFocus,
            hint: 'Nombre del responsable',
          ),
          _FindingField(
            label: 'Compromiso',
            controller: finding.commitment,
            focusNode: finding.commitmentFocus,
            hint: 'Acción y fecha comprometida',
            isLast: true,
          ),

          const SizedBox(height: 20),

          CameraImagePicker(
            minImages: 0,
            maxImages: 2,
            isPickingImage: isPickingImage,
            onPickingChanged: onPickingChanged,
            onImagesChanged: onImagesChanged,
          ),

          if (imagesMaxError)
            SizedBox(
              width: double.infinity,
              child: Text('Debe subir máximo 2 imágenes',
                style: TextStyle(color: Color.fromARGB(255, 185, 28, 16)),
              ),
            ),
        ],
      ),
    );
  }
}

class _FindingField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final int maxLines;
  final bool isLast;
  final String? Function(String?)? validator;

  const _FindingField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.focusNode,
    this.maxLines = 1,
    this.isLast = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: kAuditTextMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          GlowTextFormField(
            controller: controller,
            focusNode: focusNode,
            hint: hint,
            maxLines: maxLines,
            validator: validator,
          ),
        ],
      ),
    );
  }
}
