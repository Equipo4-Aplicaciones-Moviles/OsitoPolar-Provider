import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/OsitoButton.dart';
import '../../../../core/routing/app_route.dart';
import '../../../../core/theme/app_colors.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El color de fondo se maneja en el Container con el degradado
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.onboardingGradientStart,
              AppColors.onboardingGradientEnd,
            ],
            // Ajuste fino para que el azul cielo baje un poco más antes de volverse blanco
            stops: [0.1, 0.7],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Espacio superior para bajar un poco al oso (ya que quitamos el texto)
                const Spacer(flex: 1),

                // 2. Imagen del Oso
                Center(
                  child: Image.asset(
                    'assets/images/osito_polar_welcome.png',
                    height: 300, // Altura ajustada para verse imponente como en el diseño
                    fit: BoxFit.contain,
                  ),
                ),

                // 3. Espacio entre el oso y el título
                const Spacer(flex: 1),

                // 4. Título Grande
                const Text(
                  'Gestión de frío\nen un solo clic.',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900, // Extra Bold
                    color: AppColors.textBlack,
                    height: 1.1, // Altura de línea compacta
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),

                // 5. Subtítulo
                const Text(
                  'Monitorea, previene fallas y optimiza tus equipos desde un solo lugar.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF404040),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // 6. Botón
                OsitoButton(
                  text: 'Get started',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoute.selectProfile);
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}