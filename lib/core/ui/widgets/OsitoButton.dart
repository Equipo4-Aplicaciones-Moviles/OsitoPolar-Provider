import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class OsitoButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const OsitoButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryButton,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // --- CAMBIO AQUÍ ---
            // Reemplazamos el Icon por Image.asset
            Image.asset(
              'assets/images/bear_logo_white.png', // Asegúrate que este nombre coincida con tu archivo
              height: 28, // Tamaño similar al ícono anterior
              width: 28,
              // Opcional: Si tu imagen no es blanca pura, esto la fuerza a ser blanca
              color: Colors.white,
            ),
            // -------------------

            // Texto Centrado
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),

            // Ícono derecho (Flecha)
            const Icon(Icons.arrow_forward_ios_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}