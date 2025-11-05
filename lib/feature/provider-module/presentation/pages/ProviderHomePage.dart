import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
// 1. IMPORTAMOS EL NUEVO DRAWER
import 'package:osito_polar_app/feature/provider-dashboard/presentation/widgets/ProviderDrawer.dart';

/// Pantalla Principal del Proveedor (Empresa).
/// Muestra un resumen de equipos, mantenimientos, solicitudes y estados de cuenta.
class ProviderHomePage extends StatelessWidget {
  const ProviderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      // 2. AppBar simple (como en tu diseño), no el reutilizable
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: AppColors.cardBorder,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: AppColors.iconColor,
            size: 30,
          ),
          onPressed: () {
            // 3. ¡MODIFICADO! Esta es la lógica para abrir el Drawer
            Scaffold.of(context).openDrawer();
          },
        ),
        title: const Text(
          'OsitoPolar',
          style: TextStyle(
            color: AppColors.logoColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
      ),
      // 4. AÑADIMOS EL DRAWER AL SCAFFOLD
      drawer: const ProviderDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECCIÓN: MIS EQUIPOS ---
              _buildSectionTitle(context, 'Mis equipos'),
              const SizedBox(height: 8),
              _buildEquipmentCard(context), // <-- Esta tarjeta ahora es clickeable
              const SizedBox(height: 24),

              // --- SECCIÓN: MANTENIMIENTOS ---
              _buildSectionTitle(context, 'Mantenimientos'),
              const SizedBox(height: 8),
              _buildMaintenanceCard(context),
              const SizedBox(height: 24),

              // --- SECCIÓN: SOLICITUDES ---
              _buildSectionTitle(context, 'Solicitudes'),
              const SizedBox(height: 8),
              _buildRequestCard(context),
              const SizedBox(height: 24),

              // --- SECCIÓN: ESTADOS DE CUENTA ---
              _buildSectionTitle(context, 'Estados de cuenta'),
              const SizedBox(height: 8),
              _buildAccountStatusCard(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper para construir los títulos de sección (ej. "Mis equipos")
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

  /// Helper para la tarjeta "Mis equipos"
  Widget _buildEquipmentCard(BuildContext context) {
    // 1. Envolvemos la Card con InkWell para hacerla clickeable
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero, // El InkWell manejará el margen
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      // 2. Usamos InkWell DENTRO de la Card para obtener el efecto ripple
      child: InkWell(
        onTap: () {
          // 3. Añadimos la navegación a la pantalla de detalle
          Navigator.pushNamed(context, '/provider_equipment_detail');
        },
        borderRadius: BorderRadius.circular(12.0), // Para el efecto ripple
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Placeholder para la imagen del equipo
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.textFieldBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Icon(Icons.kitchen_outlined,
                    color: AppColors.textColor, size: 40),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vitrina vertical para congelados',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppColors.textColor),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper para la tarjeta "Mantenimientos"
  Widget _buildMaintenanceCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        children: [
          _buildMaintenanceItem(
            'Vitrina vertical para congelados',
            'Pendiende',
            Colors.orange, // Color para Pendiende
          ),
          const Divider(height: 1, color: AppColors.cardBorder),
          _buildMaintenanceItem(
            'Exhibidora de helados',
            'Realizado',
            Colors.green, // Color para Realizado
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceItem(String title, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.textColor,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper para la tarjeta "Solicitudes"
  Widget _buildRequestCard(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cámara frigorífica modular',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textColor,
              ),
            ),
            const Text(
              'Solicitado por: Mantenimiento',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.textColor),
            ),
            const Text(
              'Tiempo: 1 año',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.textColor),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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
                      backgroundColor: Colors.red,
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
    );
  }

  /// Helper para la tarjeta "Estados de cuenta"
  Widget _buildAccountStatusCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        children: [
          _buildAccountItem('FRITADO CORP', 'S/ 289.55', 'Recibido', Colors.green),
          const Divider(height: 1, color: AppColors.cardBorder),
          _buildAccountItem(
              'SOGAREN S.A.C.', 'S/ 486.5', 'Pendiente', Colors.red),
        ],
      ),
    );
  }

  Widget _buildAccountItem(
      String title, String amount, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          Text(
            status,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}