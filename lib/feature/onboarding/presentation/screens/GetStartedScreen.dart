import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/OsitoButton.dart';
import '../../../../core/routing/app_route.dart';
import '../../../../core/theme/app_colors.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.onboardingGradientStart,
              AppColors.onboardingGradientEnd,
            ],
            stops: [0.1, 0.7],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 1),

                Center(
                  child: Image.asset(
                    'assets/images/osito_polar_welcome.png', // Asegúrate de tener esta imagen o usa un Icono grande
                    height: 300,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback si no hay imagen
                      return const Icon(
                        Icons.ac_unit_rounded,
                        size: 150,
                        color: AppColors.primaryButton,
                      );
                    },
                  ),
                ),

                const Spacer(flex: 1),

                const Text(
                  'Gestión de frío\nen un solo clic.',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textBlack,
                    height: 1.1,
                    letterSpacing: -0.5,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Monitorea, previene fallas y optimiza tus equipos desde un solo lugar.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF404040),
                    height: 1.5,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 40),

                OsitoButton(
                  text: 'Comenzar',
                  onPressed: () {
                    // CAMBIO: Navegar directo al login de proveedor
                    Navigator.pushNamed(context, AppRoute.providerLogin);
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