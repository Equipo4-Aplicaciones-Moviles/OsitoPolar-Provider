import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const ProfileCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          // CAMBIO: Fondo blanco para que resalte sobre el azul de la pantalla
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // RESTAURADO: El borde azul indica cuál "login" está seleccionado
          border: Border.all(
            color: isSelected ? AppColors.primaryButton : Colors.transparent,
            width: isSelected ? 3 : 0,
          ),
          // Opcional: Sombra suave para darle profundidad como en diseños modernos
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24, // Tamaño grande
                    fontWeight: FontWeight.w900, // Extra negrita
                    color: AppColors.textBlack,
                    height: 1.1,
                  ),
                ),
                Icon(
                  icon,
                  size: 38,
                  // El ícono se pone azul si está seleccionado, negro si no
                  color: isSelected ? AppColors.primaryButton : AppColors.textBlack,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF5A6B80),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}