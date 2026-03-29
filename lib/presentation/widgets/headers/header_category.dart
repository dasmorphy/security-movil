import 'package:flutter/material.dart';

class HeaderCategory extends StatelessWidget {
  const HeaderCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Image.asset(
              'assets/images/zentinel-logo.png',
              width: 120,
              height: 36,
              fit: BoxFit.contain,
            ),

            const Spacer(),

            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(7),
                child: Icon(Icons.search, color: Colors.white),
              ),
            ),

            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                print('jjkjj');
              },
              child: const Padding(
                padding: EdgeInsets.all(7),
                child: Icon(Icons.help_outline, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
