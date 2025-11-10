import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';

/// El menú lateral (Drawer) para todas las pantallas del Proveedor.
class ProviderDrawer extends StatelessWidget {
  const ProviderDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Elimina cualquier padding del ListView
        padding: EdgeInsets.zero,
        children: <Widget>[
          // 1. Cabecera del Drawer
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryButton, // Fondo azul
            ),
            child: const Text(
              'OsitoPolar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 2. Opciones de Navegación
          _buildDrawerItem(
            context,
            icon: Icons.home,
            text: 'Inicio',
            routeName: '/provider_home',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.kitchen,
            text: 'Mis Equipos',
            // ¡Ruta corregida! Apunta a la página que ya construimos
            routeName: '/provider_my_equipments',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.people,
            text: 'Clientes y Técnicos',
            routeName: '/provider_clients_technicians',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.account_circle,
            text: 'Cuenta de Cliente', // (Ejemplo de navegación)
            routeName: '/provider_client_account',
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            text: 'Cerrar Sesión',
            routeName: '/select_profile', // Vuelve al inicio
            // TODO: Añadir lógica real de logout (limpiar token de SharedPreferences)
          ),
        ],
      ),
    );
  }

  /// Helper para construir cada item del menú
  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String text,
        required String routeName,
      }) {
    // Obtiene la ruta actual para saber si este item está "seleccionado"
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    final bool isSelected = (currentRoute == routeName);

    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primaryButton : AppColors.textColor),
      title: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          color: isSelected ? AppColors.primaryButton : AppColors.textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? AppColors.cardBackground : null,
      onTap: () {
        // Cierra el drawer
        Navigator.pop(context);

        // Si ya estamos en esa pantalla, no hacemos nada.
        // Si no, navegamos usando "pushReplacement" para no apilar pantallas
        if (!isSelected) {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
    );
  }
}