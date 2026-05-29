import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/reports')) return 1;
    if (location.startsWith('/staff')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/reports');
        break;
      case 2:
        context.go('/staff');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.only(top: 8, bottom: 24, left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home,
              filledIcon: Icons.home,
              label: 'Home',
              isSelected: selectedIndex == 0,
              onTap: () => _onItemTapped(0, context),
            ),
            _buildNavItem(
              icon: Icons.map_outlined,
              filledIcon: Icons.map,
              label: 'Map',
              isSelected: false,
              onTap: () {
                // TODO: Map feature (future phase)
              },
            ),
            _buildNavItem(
              icon: Icons.assignment_outlined,
              filledIcon: Icons.assignment,
              label: 'Reports',
              isSelected: selectedIndex == 1,
              onTap: () => _onItemTapped(1, context),
            ),
            _buildNavItem(
              icon: Icons.groups_outlined,
              filledIcon: Icons.groups,
              label: 'Staff',
              isSelected: selectedIndex == 2,
              onTap: () => _onItemTapped(2, context),
            ),
            _buildNavItem(
              icon: Icons.account_circle_outlined,
              filledIcon: Icons.account_circle,
              label: 'Profile',
              isSelected: selectedIndex == 3,
              onTap: () => _onItemTapped(3, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData filledIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? filledIcon : icon,
            color: isSelected ? AppColors.primary : AppColors.textHint,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
