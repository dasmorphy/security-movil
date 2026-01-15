import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: const Color.fromARGB(255, 15, 17, 21),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 15, 17, 21),
        border: Border(
          top: BorderSide(
            color: Colors.white24, // 👈 color del borde
            width: 1,
          ),
        )
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     const Color.fromARGB(0, 127, 199, 61),
        //     Color.fromARGB(255, 95, 175, 175),
        //   ],
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     color: const Color.fromARGB(255, 187, 58, 58).withOpacity(0.2),
        //     blurRadius: 10,
        //     offset: const Offset(0, -5),
        //   ),
        // ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          iconSize: 20,
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromARGB(0, 255, 210, 11),
          elevation: 0,
          selectedItemColor: Color.fromARGB(255, 4, 229, 221),
          selectedFontSize: 10,
          unselectedFontSize: 10,
          unselectedItemColor: Colors.white70,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              activeIcon: Icon(Icons.category),
              label: 'Categorías',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Favoritos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Formulario de salida',
            ),
          ],
        ),
      ),
    );
  }
}
