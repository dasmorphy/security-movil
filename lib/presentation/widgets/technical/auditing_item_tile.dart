import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/dispatch/commentary_reception.dart';
import 'package:zentinel/presentation/widgets/technical/auditing_colors.dart';

/// Respuestas posibles de un ítem de fiscalización.
class AuditingAnswer {
  static const yes = 'SI';
  static const no = 'NO';
  static const na = 'N/A';

  static const options = <String, String>{
    yes: 'Si',
    no: 'No',
    na: 'N/A',
  };
}

/// Ítem de fiscalización: nombre, respuesta (Si / No / N/A) y observaciones.
class AuditingItemTile extends StatelessWidget {
  final String label;
  final String? value;
  final ValueChanged<String> onChanged;
  final TextEditingController observationController;
  final FocusNode observationFocus;
  final bool hasError;

  const AuditingItemTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.observationController,
    required this.observationFocus,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      // decoration: BoxDecoration(
      //   color: kAuditSurface,
      //   borderRadius: BorderRadius.circular(12),
      //   border: Border.all(
      //     color: hasError ? kAuditDanger : kAuditBorder,
      //     width: hasError ? 1.2 : 1,
      //   ),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: AuditingAnswer.options.entries.map((option) {
              return Expanded(
                child: _AnswerOption(
                  label: option.value,
                  selected: value == option.key,
                  onTap: () => onChanged(option.key),
                ),
              );
            }).toList(),
          ),
          if (hasError) ...[
            const SizedBox(height: 8),
            const Text(
              'Selecciona una respuesta',
              style: TextStyle(color: kAuditDanger, fontSize: 12),
            ),
          ],
          const SizedBox(height: 14),
          CommentaryReception(
            controller: observationController,
            focusNode: observationFocus,
            label: 'Observaciones',
            hint: 'Escribe algún comentario...',
            minLines: 2,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? kAuditAccent : kAuditInactive,
                shape: BoxShape.circle,
              ),
              child: selected
                  ? Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? Colors.white : const Color.fromARGB(255, 210, 210, 210),
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
