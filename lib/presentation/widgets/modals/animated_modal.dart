import 'package:flutter/material.dart';

class AnimatedModal extends StatelessWidget {
  final Widget child;

  const AnimatedModal({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.89;

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
      tween: Tween(begin: 1.0, end: 0.0),
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, value * 80),
          child: Opacity(
            opacity: 1 - value,
            child: Container(
              height: height,
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
