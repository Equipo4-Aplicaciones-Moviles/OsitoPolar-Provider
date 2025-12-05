import 'package:flutter/material.dart';
import '../../theme/app_colors.dart'; // Importa tus colores

/// Un widget de footer reutilizable con el copyright y los enlaces.
class OsitoPolarFooter extends StatelessWidget {
  const OsitoPolarFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      // Usa un color de fondo ligeramente diferente si es necesario, o transparente
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Texto de Copyright
          const Text(
            '© 2025 OsitoPolar. All rights reserved.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textColor, // Color de texto normal
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // 2. Fila de enlaces (usamos Wrap para que se ajuste en pantallas pequeñas)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16.0, // Espacio horizontal entre enlaces
            runSpacing: 8.0, // Espacio vertical si se parten en dos líneas
            children: [
              _buildFooterLink(
                context,
                'Terms and Conditions',
                    () {
                  // TODO: Implementar navegación o abrir URL de Términos
                },
              ),
              _buildFooterLink(
                context,
                'Privacy Policy',
                    () {
                  // TODO: Implementar navegación o abrir URL de Privacidad
                },
              ),
              _buildFooterLink(
                context,
                'Cookie Policy',
                    () {
                  // TODO: Implementar navegación o abrir URL de Cookies
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Widget helper privado para crear los TextButton del footer
  Widget _buildFooterLink(BuildContext context, String text, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textLink, // Color de enlace (azul)
          fontFamily: 'Inter',
          decoration: TextDecoration.underline, // Subrayado
          decorationColor: AppColors.textLink,
        ),
      ),
    );
  }
}
