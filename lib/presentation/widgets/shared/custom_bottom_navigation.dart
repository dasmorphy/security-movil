import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Inicio'),
    (
      icon: Icons.category_outlined,
      activeIcon: Icons.category,
      label: 'Categorías',
    ),
    (icon: Icons.person_outline, activeIcon: Icons.person, label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    // final bottomPadding = MediaQuery.of(context).padding.bottom;

    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.navBar,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: context.isDarkMode
            ? null
            : const [BoxShadow(color: Colors.black12, blurRadius: 12)],
      ),
      padding: EdgeInsets.only(
        top: 15,
        bottom: 17,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isActive = currentIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 72,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isActive ? item.activeIcon : item.icon,
                    size: 23,
                    color: isActive ? colors.navActive : colors.navInactive,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 10,
                      color: isActive ? colors.navActive : colors.navInactive,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
