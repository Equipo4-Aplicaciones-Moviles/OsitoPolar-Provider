import 'package:flutter/material.dart';
// 1. IMPORTAMOS EL DRAWER QUE YA HICIMOS
import 'package:osito_polar_app/feature/provider-dashboard/presentation/widgets/ProviderDrawer.dart';
// 2. IMPORTAMOS TUS COLORES (si los tienes)
import 'package:osito_polar_app/core/theme/app_colors.dart';

// 🎨 Colores personalizados (según tu diseño)
const Color OsitoPolarAccentBlue = Color(0xFF1565C0); // Azul para títulos e iconos
const Color OsitoPolarButtonBlue = Color(0xFF1976D2); // Azul del botón "Actualizar"


class ProviderClientAccountPage extends StatelessWidget {
  const ProviderClientAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Fondo blanco
      backgroundColor: Colors.white,

      // ✅ Drawer que ya hicimos
      endDrawer: const ProviderDrawer(),

      // ✅ AppBar estándar (OsitoPolar a la izquierda, Menú a la derecha)
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

      // ✅ Body con scroll
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- TÍTULO ---
              _buildSectionTitle(context, 'Mi cuenta'),
              const SizedBox(height: 32),

              // --- SECCIÓN DE PERFIL ---
              _buildProfileSection(context),
              const SizedBox(height: 40),

              // --- SECCIÓN DE PLAN ACTUAL ---
              _buildCurrentPlanSection(context),
              const SizedBox(height: 40),

              // --- TARJETAS DE MEJORA DE PLAN ---
              _buildUpgradeCard(
                context,
                title: 'Plan Oro',
                description: '(Hasta 20 máquinas)',
                price: 'S/. 350 / mes',
              ),
              const SizedBox(height: 24),
              _buildUpgradeCard(
                context,
                title: 'Plan Diamante',
                description: '(Hasta 50 máquinas)',
                price: 'S/. 500 / mes',
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

  /// Helper para la sección de perfil (Avatar, Nombre, Email)
  Widget _buildProfileSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar circular
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade200,
          // Placeholder de la imagen
          backgroundImage: NetworkImage('https://placehold.co/120x120/E0E0E0/333333?text=User'),
        ),
        const SizedBox(height: 24),
        // Nombre
        Text(
          'Nombre:',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const Text(
          'Alberto Lionel',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        // Email
        Text(
          'Email:',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const Text(
          'Alberto.Lionel10@gmail.com',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  /// Helper para la sección del plan actual
  Widget _buildCurrentPlanSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Tipo de plan:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Bronce (Hasta 10 máquinas)',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: OsitoPolarAccentBlue,
          ),
        ),
      ],
    );
  }

  /// Helper para las tarjetas de mejora de plan
  Widget _buildUpgradeCard(
      BuildContext context, {
        required String title,
        required String description,
        required String price,
      }) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: OsitoPolarAccentBlue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              price,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: OsitoPolarButtonBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text(
                'Actualizar',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Footer (igual que en el home)
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