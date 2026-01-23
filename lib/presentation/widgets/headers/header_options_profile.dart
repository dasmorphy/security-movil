import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderOptionsProfile extends StatelessWidget {
  const HeaderOptionsProfile({super.key});

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
                child: const Padding(
                  padding: EdgeInsets.all(7),
                  child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                ),
              ),
            ),

            // Title (centro real)
            const Text(
              'Datos personales',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
