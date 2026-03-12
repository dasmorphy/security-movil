import 'package:flutter/material.dart';

class PulsingLogo extends StatefulWidget {
  final Widget child;

  const PulsingLogo({super.key, required this.child});

  @override
  State<PulsingLogo> createState() => _PulsingLogoState();
}

class _PulsingLogoState extends State<PulsingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return CustomPaint(
            painter: CirclePainter(controller.value),
            child: Center(child: widget.child),
          );
        },
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double value;

  CirclePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 3; i++) {
      final progress = (value + i * 0.3) % 1;

      final radius = 60 + (progress * 80);

      final opacity = (1 - progress) * 0.4;

      final paint = Paint()
        ..color = const Color.fromARGB(189, 7, 213, 213).withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
