import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/technical/auditing_colors.dart';

/// Indicador de pasos del formulario de fiscalización.
/// Muestra la etiqueta de cada paso, el círculo de estado y la línea de unión.
class AuditingStepIndicator extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final ValueChanged<int>? onStepTapped;

  const AuditingStepIndicator({
    super.key,
    required this.steps,
    required this.currentStep,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        final isCurrent = index == currentStep;
        final isDone = index < currentStep;
        final isLast = index == steps.length - 1;

        final circleColor = isCurrent || isDone ? kAuditAccent : kAuditInactive;

        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onStepTapped == null || index > currentStep
                ? null
                : () => onStepTapped!(index),
            child: Column(
              children: [
                SizedBox(
                  height: 28,
                  child: Center(
                    child: Text(
                      steps[index],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9.5,
                        height: 1.15,
                        color: isCurrent ? Colors.white : kAuditTextMuted,
                        fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index == 0
                            ? Colors.transparent
                            : (isDone || isCurrent ? kAuditAccent : kAuditInactive),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: isCurrent ? 24 : 20,
                      height: isCurrent ? 24 : 20,
                      decoration: BoxDecoration(
                        color: circleColor,
                        shape: BoxShape.circle,
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: kAuditAccentSoft.withValues(alpha: 0.45),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ]
                            : [],
                      ),
                      child: isDone
                          ? const Icon(Icons.check, size: 13, color: Colors.white)
                          : null,
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isLast
                            ? Colors.transparent
                            : (isDone ? kAuditAccent : kAuditInactive),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
