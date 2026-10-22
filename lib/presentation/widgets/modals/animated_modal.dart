import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';

class AnimatedModal extends StatelessWidget {
  final Widget child;

  const AnimatedModal({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height * 0.89;
    final bottomInset = mediaQuery.viewInsets.bottom;

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      tween: Tween(begin: 1.0, end: 0.0),
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, value * 80),
          child: Opacity(
            opacity: 1 - value,
            child: Padding(
              // 🔑 ESTO ES LO QUE HACE SUBIR EL MODAL
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: context.colors.sheet,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
