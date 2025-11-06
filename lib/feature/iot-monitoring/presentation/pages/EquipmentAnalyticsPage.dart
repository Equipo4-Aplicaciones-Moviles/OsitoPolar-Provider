import 'package:flutter/material.dart';

// --- ¡¡¡IMPORTACIONES CORREGIDAS!!! ---
// He quitado el Drawer y AppColors que NO existen en esta rama.

// Importamos los nuevos widgets que creaste
// (La ruta asume que 'analytics_widgets' está dentro de 'pages')
import 'analytics_widgets/AnalyticsInfoCard.dart';
import 'analytics_widgets/AnalyticsChartCard.dart';
import 'analytics_widgets/AnalyticsMapCard.dart';

// --- Colores locales (del Figma) ---
const Color OsitoPolarBackground = Color(0xFFF5F8F6); // Fondo verde-gris claro
const Color OsitoPolarAccentBlue = Color(0xFF1565C0);
const Color OsitoPolarRed = Color(0xFFE53935);
const Color OsitoPolarGreenButton = Color(0xFF4CAF50);
const Color OsitoPolarTextLight = Color(0xFF6c757d);
const Color ositoPolarFooterLinks = Color(0xFF0D47A1);

class EquipmentAnalyticsPage extends StatelessWidget {
  const EquipmentAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Color de fondo del Figma
      backgroundColor: OsitoPolarBackground,

      // ❌ Drawer ELIMINADO (causaba los errores)
      // endDrawer: const ProviderDrawer(),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.2),
        // ✅ Flecha de regreso (como en tu emulador)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: OsitoPolarAccentBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "OsitoPolar",
          style: TextStyle(
            color: OsitoPolarAccentBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,

        // ❌ Botón de Menú ELIMINADO
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Título ---
              const Text(
                'Industrial Freezer XK-400\nAnalytics',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: OsitoPolarAccentBlue,
                ),
              ),
              const SizedBox(height: 24),

              // --- Grid 2x2 ---
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: const [
                  AnalyticsInfoCard(
                    title: 'Current Temperature',
                    value: '-2.5 C',
                    valueColor: OsitoPolarAccentBlue,
                  ),
                  AnalyticsInfoCard(
                    title: 'Set Temperature',
                    value: '-5.0 C',
                    subtitle: 'Optimal range: -6.0 - 1',
                    valueColor: OsitoPolarTextLight,
                  ),
                  AnalyticsInfoCard(
                    title: 'Power Status',
                    value: 'ON',
                    valueColor: OsitoPolarGreenButton,
                  ),
                  AnalyticsInfoCard(
                    title: 'Current Temperature',
                    value: '-2.5 C',
                    valueColor: OsitoPolarAccentBlue,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- Gráficas y Mapa ---
              AnalyticsChartCard(title: 'Temperature Over Time'),
              const SizedBox(height: 24),
              AnalyticsChartCard(title: 'Daily Temperature Averages (7d)'),
              const SizedBox(height: 24),
              AnalyticsMapCard(),
              const SizedBox(height: 48),

              // --- Footer ---
              _buildPageFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets privados de esta página (Footer) ---

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
              color: OsitoPolarTextLight,
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