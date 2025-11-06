import 'package:flutter/material.dart';
// 1. IMPORTAMOS EL DRAWER QUE YA HICIMOS
import 'package:osito_polar_app/feature/provider-dashboard/presentation/widgets/ProviderDrawer.dart';
// 2. IMPORTAMOS TUS COLORES
import 'package:osito_polar_app/core/theme/app_colors.dart';

// 🎨 Colores personalizados (según tu diseño)
const Color OsitoPolarAccentBlue = Color(0xFF1565C0); // Azul para títulos e iconos
const Color OsitoPolarGreenButton = Color(0xFF4CAF50);
const Color OsitoPolarRedButton = Color(0xFFE53935);


class ProviderHomePage extends StatelessWidget {
  const ProviderHomePage({super.key});

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
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: OsitoPolarAccentBlue),
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
              // --- AHORA CON LAS CAJAS GRISES ESTÁTICAS ---
              _buildEquipmentSection(context),
              const SizedBox(height: 32),

              // --- SECCIÓN: MANTENIMIENTOS ---
              _buildSectionTitle(context, 'Mantenimientos'),
              const SizedBox(height: 16),
              // Esta sección no tiene cajas grises, solo padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    _maintenanceCardItem(
                      "Vitrina vertical para congelados",
                      "Pendiente",
                      OsitoPolarRedButton,
                    ),
                    const SizedBox(height: 8),
                    _maintenanceCardItem(
                      "Exhibidora de helados",
                      "Realizado",
                      OsitoPolarGreenButton,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- SECCIÓN: SOLICITUDES ---
              _buildSectionTitle(context, 'Solicitudes'),
              const SizedBox(height: 16),
              // --- AHORA CON LAS CAJAS GRISES ESTÁTICAS ---
              _buildRequestSection(context),
              const SizedBox(height: 32),

              // --- SECCIÓN: ESTADOS DE CUENTA ---
              _buildSectionTitle(context, 'Estados de cuenta'),
              const SizedBox(height: 16),
              // Esta sección no tiene cajas grises, solo padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    _accountStatementCard(
                      "FRITMO CORP",
                      "S/. 2351.23",
                      "Recibido",
                      OsitoPolarGreenButton,
                    ),
                    const SizedBox(height: 8),
                    _accountStatementCard(
                      "COOLPROV S.A.C.",
                      "S/. 458.5",
                      "Pendiente",
                      OsitoPolarRedButton,
                    ),
                  ],
                ),
              ),
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
      // Ocupa el 70% del ancho de la pantalla
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
              Image.network(
                'https://placehold.co/150x200/FFFFFF/333333?text=Vitrina',
                height: 180,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.kitchen_outlined, size: 80, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              const Text(
                "Vitrina vertical para congelados",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // La fila completa: [caja] [tarjeta] [caja]
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Empuja las cajas a los lados
      crossAxisAlignment: CrossAxisAlignment.center, // Centra verticalmente
      children: [
        _buildGreyBox(),
        card, // La tarjeta va en medio
        _buildGreyBox(),
      ],
    );
  }

  /// Helper para la tarjeta "Solicitudes" (con cajas grises)
  Widget _buildRequestSection(BuildContext context) {

    // La tarjeta central
    final card = SizedBox(
      // Ocupa el 70% del ancho de la pantalla
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
                'Solicitado por: Nahuel Barrera',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12),
              ),
              const Text(
                'Tiempo: 1 año',
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
                      child: const Text('Aceptar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: OsitoPolarRedButton,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Denegar'),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Empuja las cajas a los lados
      crossAxisAlignment: CrossAxisAlignment.center, // Centra verticalmente
      children: [
        _buildGreyBox(),
        card, // La tarjeta va en medio
        _buildGreyBox(),
      ],
    );
  }

  // Tarjeta de Mantenimiento (sin cambios)
  static Widget _maintenanceCardItem(String title, String status, Color statusColor) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              status,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tarjeta de Estados de Cuenta (sin cambios)
  static Widget _accountStatementCard(
      String client, String amount, String status, Color statusColor) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              flex: 45,
              child: Text(
                client,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 30,
              child: Text(
                amount,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              flex: 25,
              child: Text(
                status,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
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