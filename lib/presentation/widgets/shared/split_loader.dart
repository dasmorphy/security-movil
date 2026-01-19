import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplitLoader extends StatelessWidget {
  final String? message;
  final Color backgroundColor;
  final Color loadingColor;
  final double loadingSize;

  const SplitLoader({
    super.key,
    this.message,
    this.backgroundColor = const Color(0xCC000000), // Negro semi-transparente más oscuro
    this.loadingColor = const Color.fromARGB(190, 58, 199, 199),
    this.loadingSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1500,
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingAnimationWidget.inkDrop(
              color: loadingColor,
              size: loadingSize,
            ),
            if (message != null) ...[
              // const SizedBox(height: 40),
              Text(
                message!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

