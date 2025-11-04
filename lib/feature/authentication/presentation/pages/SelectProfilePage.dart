import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart'; // Importa tus colores

/// Pantalla para seleccionar entre perfil "Cliente" o "Empresa".
/// Esta es la primera pantalla que ve el usuario.
class SelectProfilePage extends StatelessWidget {
  // Callbacks para manejar la navegación
  final VoidCallback onClientClicked;
  final VoidCallback onProviderClicked;

  const SelectProfilePage({
    super.key,
    required this.onClientClicked,
    required this.onProviderClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Color de fondo principal de la app
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        // 2. Centramos la tarjeta en la pantalla
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Padding alrededor de la tarjeta
          child: Card(
            // 3. Tarjeta con el estilo de OsitoPolar
            elevation: 0,
            color: AppColors.cardBackground, // Fondo F2
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: const BorderSide(
                color: AppColors.cardBorder, // Borde F1
                width: 1,
              ),
            ),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // La tarjeta se ajusta al contenido
                crossAxisAlignment: CrossAxisAlignment.stretch, // Estira los botones
                children: [
                  // 4. Logo "OsitoPolar"
                  Text(
                    'OsitoPolar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.title, // Color 208AC9
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 64.0),

                  // 5. Botón de Cliente
                  ElevatedButton(
                    onPressed: onClientClicked,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryButton, // Color 0079C2
                      foregroundColor: AppColors.buttonLabel, // Color FFFFFF
                      minimumSize: const Size(double.infinity, 50), // Ancho completo
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Cliente',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // 6. Botón de Empresa
                  ElevatedButton(
                    onPressed: onProviderClicked,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryButton, // Color 0079C2
                      foregroundColor: AppColors.buttonLabel, // Color FFFFFF
                      minimumSize: const Size(double.infinity, 50), // Ancho completo
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Empresa',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}