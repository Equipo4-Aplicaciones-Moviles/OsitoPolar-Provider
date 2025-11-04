import 'package:flutter/material.dart';
import '../../theme/app_colors.dart'; // Importa tus colores

/// Un AppBar reutilizable con el estilo de OsitoPolar.
///
/// Muestra un ícono de menú a la izquierda y el logo/título en el centro.
class OsitoPolarTopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuClicked;

  const OsitoPolarTopBar({
    super.key,
    this.onMenuClicked,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Fondo transparente para que use el color del Scaffold
      backgroundColor: Colors.transparent,
      elevation: 0, // Sin sombra
      // Ícono del menú a la izquierda
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          color: AppColors.iconColor, // Usa el color del logo
          size: 30,
        ),
        onPressed: onMenuClicked,
        tooltip: 'Menú',
      ),
      // Título "OsitoPolar" centrado
      centerTitle: true,
      title: const Text(
        'OsitoPolar',
        style: TextStyle(
          color: AppColors.logoColor, // Usa el color del logo
          fontWeight: FontWeight.bold,
          fontSize: 24,
          fontFamily: 'Inter', // Asegúrate de tener la fuente 'Inter'
        ),
      ),
    );
  }

  /// Define la altura estándar de un AppBar.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}