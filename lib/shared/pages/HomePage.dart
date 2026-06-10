import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:iventi/shared/theme/AppColors.dart';

class HomePage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomePage({super.key, required this.navigationShell});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(color: Colors.black, overflow: TextOverflow.ellipsis),
          unselectedLabelStyle: const TextStyle(color: Colors.black, overflow: TextOverflow.ellipsis),
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.black,
          backgroundColor: AppColors.primary,
          currentIndex: widget.navigationShell.currentIndex,
          onTap: _goBranch,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.inventory_2),
              label: "Inventario",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.point_of_sale),
              label: "Ventas",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people),
              label: "Clientes",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.assessment),
              label: "Reportes",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: "Configuraciones",
            ),
          ],
        ),
      ),
    );
  }
}
