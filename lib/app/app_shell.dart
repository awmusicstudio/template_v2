import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final String location;
  const AppShell({required this.child, required this.location, super.key});

  static const int _desktopBreakpoint = 800;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= _desktopBreakpoint;
        if (isWide) {
          // Desktop / tablet layout with NavigationRail
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _indexFromLocation(location),
                  onDestinationSelected: (idx) => _onNavTap(context, idx),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            ),
          );
        } else {
          // Mobile layout with BottomNavigationBar + AppBar
          return Scaffold(
            appBar: AppBar(title: const Text('template_v2')),
            body: child,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _indexFromLocation(location),
              onTap: (idx) => _onNavTap(context, idx),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          );
        }
      },
    );
  }

  int _indexFromLocation(String location) {
    if (location.startsWith('/settings')) return 1;
    return 0;
  }

  void _onNavTap(BuildContext context, int idx) {
    switch (idx) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/settings');
        break;
    }
  }
}
