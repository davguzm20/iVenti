import 'package:flutter/material.dart';
import 'package:iventi/shared/utils/NavigationItems.dart';

class NavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(color: Colors.black),
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
        backgroundColor: const Color(0xFF493D9E),
        currentIndex: currentIndex,
        onTap: onTap,
        items: NavigationItems.items.map((item) {
          return BottomNavigationBarItem(
            icon: Image.asset(
              item['icon'] as String,
              width: 30,
              height: 30,
            ),
            label: item['label'] as String,
          );
        }).toList(),
      ),
    );
  }
}
