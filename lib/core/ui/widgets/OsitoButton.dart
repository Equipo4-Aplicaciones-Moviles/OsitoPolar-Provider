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
            // Logo del oso blanco (Asegúrate de tener el asset 'bear_logo_white.png')
            Image.asset(
              'assets/images/bear_logo_white.png',
              height: 28,
              width: 28,
              color: Colors.white,
              errorBuilder: (c, e, s) => const Icon(Icons.catching_pokemon, color: Colors.white), // Fallback
            ),

            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),

            const Icon(Icons.arrow_forward_ios_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}