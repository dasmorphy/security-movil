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
        color: const Color.fromARGB(255, 34, 33, 33),
        // border: Border(
        //   top: BorderSide(
        //     color: Colors.white24, // 👈 color del borde
        //     width: 1,
        //   ),
        // )
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      child: SizedBox(
        height: 62,
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
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.favorite_outline),
              //   activeIcon: Icon(Icons.favorite),
              //   label: 'Favoritos',
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
