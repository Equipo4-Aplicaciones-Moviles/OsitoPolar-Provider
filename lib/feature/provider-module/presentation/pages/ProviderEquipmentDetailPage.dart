// --- ¡¡¡ESTAS 3 LÍNEAS SON LAS MÁS IMPORTANTES!!! ---
import 'package:flutter/material.dart';
import 'package:osito_polar_app/feature/provider-dashboard/presentation/widgets/ProviderDrawer.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
// ----------------------------------------------------

// 🎨 Colores personalizados (según tu diseño)
const Color OsitoPolarAccentBlue = Color(0xFF1565C0); // Azul para títulos e iconos
const Color OsitoPolarGreenButton = Color(0xFF4CAF50);
const Color OsitoPolarRedButton = Color(0xFFE53935);


class ProviderEquipmentDetailPage extends StatelessWidget {
  const ProviderEquipmentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Fondo blanco
      backgroundColor: Colors.white,

      // ✅ Drawer que ya hicimos
      endDrawer: const ProviderDrawer(),

      // ✅ AppBar corregida al Figma
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.2),

        // --- Flecha de regreso al HOME ---
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: OsitoPolarAccentBlue, // Icono azul
          ),
          onPressed: () {
            // Te lleva de vuelta al Home
            Navigator.pushReplacementNamed(context, '/provider_home');
          },
        ),

        title: const Text(
          "OsitoPolar",
          style: TextStyle(
            color: OsitoPolarAccentBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false, // Título a la izquierda
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: OsitoPolarAccentBlue),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ✅ Body es un simple SingleChildScrollView
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- SECCIÓN: MIS EQUIPOS ---
              _buildSectionTitle(context, 'Mis equipos'),
              const SizedBox(height: 16),
              _buildEquipmentSection(context),
              const SizedBox(height: 32),

              // --- SECCIÓN: MANTENIMIENTOS ---
              _buildSectionTitle(context, 'Mantenimientos'),
              const SizedBox(height: 16),
              _buildMaintenanceSection(context),
              const SizedBox(height: 48),

              // --- Footer al final de la página ---
              _buildPageFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper para construir los títulos de sección (Centrado y Azul)
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: OsitoPolarAccentBlue,
        ),
      ),
    );
  }

  // --- WIDGET PARA LA CAJA GRIS DECORATIVA ---
  Widget _buildGreyBox() {
    return Container(
      width: 30, // Ancho de la caja gris
      height: 100, // Alto de la caja gris
      decoration: BoxDecoration(
        color: Colors.grey.shade300, // Color gris del Figma
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  /// Helper para la tarjeta "Mis equipos" (con cajas grises)
  Widget _buildEquipmentSection(BuildContext context) {

    // La tarjeta central
    final card = SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Fila de Iconos Superiores ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.power_settings_new, color: Colors.green, size: 28),
                  Icon(Icons.circle, color: Colors.green, size: 16),
                ],
              ),
              const SizedBox(height: 12),

              // --- Título ---
              const Text(
                "Industrial Freezer XK-400\nCongelador XK-400",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // --- Imagen ---
              Image.network(
                'https://placehold.co/150x200/FFFFFF/333333?text=Vitrina',
                height: 120, // Más pequeña que en el home
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.kitchen_outlined, size: 80, color: Colors.grey),
              ),
              const SizedBox(height: 12),

              // --- Temperatura ---
              const Text(
                "25°",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: OsitoPolarAccentBlue,
                ),
              ),
              Text(
                "(normal)",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),

              // --- Ubicación ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.grey.shade600, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    "San Isidro Main Warehouse",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Botones ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón Control
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.settings, size: 16),
                    label: const Text('Control'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OsitoPolarAccentBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Botones de Editar y Borrar
                  _buildIconButton(Icons.edit, OsitoPolarAccentBlue),
                  _buildIconButton(Icons.delete, OsitoPolarRedButton),
                ],
              )
            ],
          ),
        ),
      ),
    );

    // La fila completa: [caja] [tarjeta] [caja]
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildGreyBox(),
        card,
        _buildGreyBox(),
      ],
    );
  }

  // Helper para los botones de icono redondos
  Widget _buildIconButton(IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 18),
        onPressed: () {},
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(), // 'const' añadido
      ),
    );
  }

  /// Helper para la tarjeta "Mantenimientos" (con cajas grises)
  Widget _buildMaintenanceSection(BuildContext context) {

    // La tarjeta central
    final card = SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Card(
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                  Icons.ac_unit,
                  size: 50,
                  color: OsitoPolarAccentBlue.withOpacity(0.7)
              ),
              const SizedBox(height: 16),
              const Text(
                'Cámara frigorífica modular',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Cliente: Nahuel Barrera', // Como en el Figma
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: OsitoPolarGreenButton,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Realizar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // --- Botón Denegar es solo texto ---
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Denegar',
                        style: TextStyle(
                          color: OsitoPolarRedButton,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    // La fila completa: [caja] [tarjeta] [caja]
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildGreyBox(),
        card,
        _buildGreyBox(),
      ],
    );
  }

  // Footer (sin cambios)
  static Widget _buildPageFooter(BuildContext context) {
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
              color: Colors.grey.shade600,
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

  static Widget _buildFooterLink(String text) {
    return InkWell(
      onTap: () {
        // TODO: Implementar navegación
        print('Navegar a: $text');
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: OsitoPolarAccentBlue, // Enlaces en azul
          decoration: TextDecoration.underline,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}