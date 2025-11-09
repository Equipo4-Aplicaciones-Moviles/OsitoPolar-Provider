import 'package:flutter/material.dart';

class ProviderDrawer extends StatelessWidget {
  final void Function(String route)? onItemSelected;
  const ProviderDrawer({super.key, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = MediaQuery.of(context).size.width * 0.75;

    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        backgroundColor: const Color(0xFF5B9FD3), // Azul Figma (OsitoPolarDesignBlue)
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDrawerItem(context, 'HOME', '/provider_home'),
              _buildDrawerItem(context, 'My Machines', '/provider_equipment_detail'),
              _buildDrawerItem(context, 'Rent', '/rent_page'),
              _buildDrawerItem(context, 'Contact', '/contact_page'),
              _buildDrawerItem(context, 'Notifications', '/notifications_page'),
              _buildDrawerItem(context, 'Mi cuenta', '/account_page'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String text, String routeName) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Cierra el drawer
        Navigator.pushReplacementNamed(context, routeName);
        onItemSelected?.call(routeName);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 28, // Tamaño grande como en Compose
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Inter',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
