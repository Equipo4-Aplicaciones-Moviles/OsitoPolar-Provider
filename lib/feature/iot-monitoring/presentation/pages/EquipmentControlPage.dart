import 'package:flutter/material.dart';

// --- ¡¡¡IMPORTACIONES CORREGIDAS!!! ---
// He quitado los imports a ProviderDrawer y app_colors que NO existen en esta rama.
// Esta ruta SÍ funciona porque 'widgets' está dentro de 'pages'
import 'widgets/ControlCarousel.dart';
import 'widgets/EquipmentInfoCard.dart';
import 'widgets/ControlCarousel.dart';
import 'widgets/EquipmentInfoCard.dart';
// ---------------------------------------------------

// --- ¡¡¡COLORES DEL FIGMA!!! ---
// Definidos aquí localmente para que no den error
const Color ositoPolarBackground = Color(0xFFF5F8F6); // Fondo verde-gris claro
const Color ositoPolarAccentBlue = Color(0xFF1565C0);
const Color ositoPolarFooterLinks = Color(0xFF0D47A1);
const Color ositoPolarTextDark = Color(0xFF333333);
const Color ositoPolarTextLight = Color(0xFF6c757d);

class EquipmentControlPage extends StatelessWidget {
  const EquipmentControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Color de fondo del Figma
      backgroundColor: ositoPolarBackground,

      // --- DRAWER (COMENTADO HASTA QUE LO IMPORTES) ---
      // Para que esto funcione, necesitas importar tu ProviderDrawer.dart
      // endDrawer: const ProviderDrawer(),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.2),
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: ositoPolarAccentBlue),
        title: const Text(
          "OsitoPolar",
          style: TextStyle(
            color: ositoPolarAccentBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,

        // --- ¡¡¡AQUÍ ESTÁN LAS 3 RAYITAS!!! ---
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: ositoPolarAccentBlue),
              onPressed: () {
                // --- ESTA LÍNEA ESTÁ COMENTADA ---
                // Descoméntala cuando importes tu ProviderDrawer
                // Scaffold.of(context).openEndDrawer();
                print("Botón de menú presionado!"); // Para probar
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Título y Subtítulo ---
              _buildSectionTitle(
                  context,
                  'Control de equipos',
                  'Mini Refrigerator MR-100'
              ),
              const SizedBox(height: 16),

              // --- WIDGET 1: El Carrusel ---
              // Esto ahora funcionará
              const ControlCarousel(),

              const SizedBox(height: 32),

              // --- WIDGET 2: La Tarjeta de Info ---
              // Esto ahora funcionará
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const EquipmentInfoCard(),
              ),
              const SizedBox(height: 48),

              // --- WIDGET 3: El Footer ---
              _buildPageFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets privados de esta página (Título y Footer) ---

  Widget _buildSectionTitle(BuildContext context, String title, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: ositoPolarAccentBlue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 16,
            color: ositoPolarTextLight,
          ),
        ),
      ],
    );
  }

  Widget _buildPageFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '© 2025 OsitoPolar. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: ositoPolarTextLight,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterLink('Terms and Conditions'),
              const SizedBox(width: 8),
              _buildFooterLink('Privacy Policy'),
              const SizedBox(width: 8),
              _buildFooterLink('Cookie Policy'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return InkWell(
      onTap: () {},
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: ositoPolarFooterLinks,
          decoration: TextDecoration.underline,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}