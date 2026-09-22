import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF161F33),
            title: const Text('¿Salir de Nota Premium?', style: TextStyle(color: Colors.white)),
            content: const Text('¿Estás seguro que deseas salir de la aplicación?', style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar', style: TextStyle(color: Color(0xFF00E676))),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Salir', style: TextStyle(color: Color(0xFFE94057))),
              ),
            ],
          ),
        ) ?? false;

        if (shouldExit) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: navigationShell,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: _goBranch,
              elevation: 0,
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                _buildNavItem(Icons.home_outlined, 0),
                _buildNavItem(Icons.credit_card_outlined, 1),
                _buildNavItem(Icons.sticky_note_2_outlined, 2),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    final isSelected = navigationShell.currentIndex == index;
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFF00E676).withOpacity(0.2), // Teal glow
                shape: BoxShape.circle,
              )
            : null,
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF00E676) : const Color(0xFF8E9BB0),
        ),
      ),
      label: '',
    );
  }
}
