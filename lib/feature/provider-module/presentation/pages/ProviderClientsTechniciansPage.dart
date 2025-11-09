import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';

/// Pantalla del Proveedor para gestionar Clientes, Órdenes y Técnicos.
class ProviderClientsTechniciansPage extends StatelessWidget {
  const ProviderClientsTechniciansPage({super.key});

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
            Icons.arrow_back, // O Icons.menu si es la principal
            color: AppColors.iconColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'OsitoPolar', // El diseño aún muestra el logo
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECCIÓN: MIS CLIENTES ---
              _buildSectionTitle(context, 'Mis clientes'),
              const SizedBox(height: 8),
              _buildClientsCard(context),
              _buildViewMoreLink('Ver historial de clientes', () {
                // TODO: Navegar a la lista completa de clientes
              }),
              const SizedBox(height: 24),

              // --- SECCIÓN: ÓRDENES DE TRABAJO ---
              _buildSectionTitle(context, 'Órdenes de trabajo'),
              const SizedBox(height: 8),
              _buildWorkOrdersCard(context),
              _buildViewMoreLink('Ver órdenes de trabajo', () {
                // TODO: Navegar a la lista completa de órdenes
              }),
              const SizedBox(height: 24),

              // --- SECCIÓN: TÉCNICOS ---
              _buildSectionTitle(context, 'Técnicos'),
              const SizedBox(height: 8),
              _buildTechniciansCard(context),
              _buildViewMoreLink('Ver lista de técnicos', () {
                // TODO: Navegar a la lista completa de técnicos
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper para los títulos (ej. "Mis clientes")
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: AppColors.title,
      ),
    );
  }

  /// Helper para los enlaces "Ver más..."
  Widget _buildViewMoreLink(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          color: AppColors.textLink,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  /// Helper para la tarjeta "Mis clientes"
  Widget _buildClientsCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        children: [
          _buildClientItem(
              'Miyuki Marino S.A.', '16/04/25', '999123123'), // Datos de ejemplo
          const Divider(height: 1, color: AppColors.cardBorder),
          _buildClientItem(
              'Comercial Don Lucho S.A.C.', '10/04/25', '987654321'),
          const Divider(height: 1, color: AppColors.cardBorder),
          _buildClientItem(
              'SAB Horeca S.A.C.', '09/04/25', '998877665'),
        ],
      ),
    );
  }

  Widget _buildClientItem(String name, String date, String phone) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.textColor,
                ),

              ),
            ],
          ),
          Text(
            phone,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Helper para la tarjeta "Órdenes de trabajo"
  Widget _buildWorkOrdersCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        children: [
          _buildWorkOrderItem(
              'Cliente XY007...', 'Reparación...', '15/03/25', Colors.orange),
          const Divider(height: 1, color: AppColors.cardBorder),
          _buildWorkOrderItem(
              'Cliente XZ008...', 'Instalación...', '16/03/25', Colors.green),
          const Divider(height: 1, color: AppColors.cardBorder),
          _buildWorkOrderItem(
              'Cliente XA009...', 'Mantenimiento...', '21/03/25', Colors.red),
        ],
      ),
    );
  }

  Widget _buildWorkOrderItem(
      String client, String job, String date, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                client,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                job,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          Text(
            date,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Helper para la tarjeta "Técnicos"
  Widget _buildTechniciansCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTechnicianItem('Rivas Uribe Carlos'),
          const Divider(height: 1, color: AppColors.cardBorder),
          _buildTechnicianItem('Rodriguez Montes Juan'),
          const Divider(height: 1, color: AppColors.cardBorder),
          _buildTechnicianItem('Piedra Uribe Carlos'),
        ],
      ),
    );
  }

  Widget _buildTechnicianItem(String name) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        name,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: AppColors.textColor,
        ),
      ),
    );
  }
}