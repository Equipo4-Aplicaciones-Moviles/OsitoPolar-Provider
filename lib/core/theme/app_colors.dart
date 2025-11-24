import 'package:flutter/material.dart';

class AppColors {

  // ------------------------------------------------------------------------
  // --- NUEVOS COLORES (Para que funcione el diseño nuevo) ---
  // ------------------------------------------------------------------------

  // 1. Degradado para la pantalla "Get Started"
  static const Color onboardingGradientStart = Color(0xFF90C0FD);
  static const Color onboardingGradientEnd = Color(0xFFE8F4FF);

  // 2. Color sólido de fondo (Faltaba este para SelectProfileScreen)
  // Lo ponemos igual al final del degradado para que se vea suave.
  static const Color onboardingBackground = Color(0xFFE8F4FF);

  // 3. Colores para las tarjetas y textos
  static const Color cardLightBackground = Color(0xFFE2F1FF);
  static const Color textBlack = Color(0xFF1A1A1A);

  // ------------------------------------------------------------------------
  // --- TUS COLORES ORIGINALES (No borrar) ---
  // ------------------------------------------------------------------------
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color cardBackground = Color(0xFFEBEFF5);
  static const Color cardBorder = Color(0xFFCFD8E8);
  static const Color primaryButton = Color(0xFF0079C2);
  static const Color buttonLabel = Color(0xFFFFFFFF);
  static const Color title = Color(0xFF208AC9);
  static const Color textColor = Color(0xFF333333);
  static const Color textLink = Color(0xFF208AC9);
  static const Color textFieldBackground = Color(0xFFDCE3EE);
  static const Color textFieldBorder = Color(0xFFCFD8E8);
  static const Color logoColor = Color(0xFF208AC9);
  static const Color iconColor = Color(0xFF208AC9);
}