import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class HeaderOptionsProfile extends StatelessWidget {
  final String headerTxt;
  const HeaderOptionsProfile({super.key, required this.headerTxt});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Back button (izquierda)
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => context.pop(),
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Icon(Icons.arrow_back_ios_new, color: context.colors.icon),
                ),
              ),
            ),

            // Title
            Text(
              headerTxt,
              style: TextStyle(
                fontSize: 16,
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
