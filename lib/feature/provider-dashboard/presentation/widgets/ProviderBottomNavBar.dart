import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';

class ProviderBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ProviderBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.white,
      elevation: 3,
      indicatorColor: AppColors.primaryButton.withOpacity(0.2),
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      // 'labelBehavior' ayuda cuando hay muchos iconos
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard, color: AppColors.primaryButton),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2, color: AppColors.primaryButton),
          label: 'Equipos',
        ),
        NavigationDestination(
          icon: Icon(Icons.storefront_outlined),
          selectedIcon: Icon(Icons.storefront, color: AppColors.primaryButton),
          label: 'Market',
        ),
        // --- NUEVO ÍTEM: TÉCNICOS ---
        NavigationDestination(
          icon: Icon(Icons.people_outline),
          selectedIcon: Icon(Icons.people, color: AppColors.primaryButton),
          label: 'Técnicos',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person, color: AppColors.primaryButton),
          label: 'Perfil',
        ),
      ],
    );
  }
}