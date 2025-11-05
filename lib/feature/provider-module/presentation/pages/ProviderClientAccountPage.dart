import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';

/// Pantalla del Proveedor para ver el detalle de la cuenta de un Cliente.
/// Muestra el plan actual y las opciones de actualización.
class ProviderClientAccountPage extends StatelessWidget {
  const ProviderClientAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: AppColors.cardBorder,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.iconColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Mi cuenta', // Título según el diseño
          style: TextStyle(
            color: AppColors.logoColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- TARJETA DE PERFIL DEL CLIENTE ---
              _buildProfileCard(context),
              const SizedBox(height: 24),

              // --- TARJETA DEL PLAN ACTUAL ---
              _buildCurrentPlanCard(context),
              const SizedBox(height: 24),

              // --- SECCIÓN DE MEJORA DE PLANES ---
              Row(
                children: [
                  // Tarjeta Plan Oro
                  Expanded(
                    child: _buildUpgradePlanCard(
                      context,
                      'Plan Oro',
                      '(Hasta 20 máquinas)',
                      AppColors.primaryButton, // Botón azul
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Tarjeta Plan Diamante
                  Expanded(
                    child: _buildUpgradePlanCard(
                      context,
                      'Plan Diamante',
                      '(Hasta 50 máquinas)',
                      AppColors.primaryButton, // Botón azul
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper para la tarjeta de Perfil
  Widget _buildProfileCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Círculo de la imagen de perfil
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.textFieldBackground,
              // TODO: Reemplazar con una imagen de red (Image.network)
              child: Icon(
                Icons.person,
                size: 40,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildProfileInfoRow('Nombre:', 'Alberto Lionel'),
            const SizedBox(height: 4),
            _buildProfileInfoRow('Email:', 'Alberto.lionel@...'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }

  /// Helper para la tarjeta de Plan Actual
  Widget _buildCurrentPlanCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            Text(
              'Tipo de plan',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Bronce (hasta 10 máquinas)',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.title,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper para las tarjetas de "Mejorar Plan"
  Widget _buildUpgradePlanCard(
      BuildContext context, String title, String subtitle, Color buttonColor) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.title,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Lógica para actualizar plan
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: AppColors.buttonLabel,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}