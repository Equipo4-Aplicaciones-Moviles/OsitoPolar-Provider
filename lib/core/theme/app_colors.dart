import 'package:flutter/material.dart';

// Paleta de colores principal de la marca "OsitoPolar"
// Basada en la guía de estilos: https://... (tu enlace de Figma/guía)

class AppColors {
  // --- Colores de Fondo ---
  /// Color de fondo principal de la app (Background F5F7FA)
  static const Color backgroundLight = Color(0xFFF5F7FA);

  /// Color para el fondo de las tarjetas (F2 EBEFF5)
  static const Color cardBackground = Color(0xFFEBEFF5);

  /// Color para el borde de las tarjetas (F1 CFD8E8)
  static const Color cardBorder = Color(0xFFCFD8E8);

  // --- Botones ---
  /// Color principal para botones (Buttons 0079C2)
  static const Color primaryButton = Color(0xFF0079C2);

  /// Color para el texto dentro de los botones (Button label FFFFFF)
  static const Color buttonLabel = Color(0xFFFFFFFF);

  // --- Texto ---
  /// Color principal para títulos (Title 208AC9)
  static const Color title = Color(0xFF208AC9);

  /// Color para el texto normal (ej. "Contraseña", "Recordarme")
  /// (Usaremos un negro/gris estándar, ya que no se especificó)
  static const Color textColor = Color(0xFF333333);

  /// Color para los enlaces del footer (ej. "Términos y Condiciones")
  /// (Usaremos el color de título)
  static const Color textLink = Color(0xFF208AC9);

  /// Color de fondo para campos de texto (Text field DCE3EE)
  static const Color textFieldBackground = Color(0xFFDCE3EE);

  /// Color para el borde de los campos de texto
  /// (Usaremos el mismo borde de las tarjetas para consistencia)
  static const Color textFieldBorder = Color(0xFFCFD8E8);

  /// Color del logo en el TopBar (Asumiendo que es el mismo color 'Title')
  static const Color logoColor = Color(0xFF208AC9);

  /// Color del ícono de menú en el TopBar (Asumiendo que es el mismo color 'Title')
  static const Color iconColor = Color(0xFF208AC9);
}