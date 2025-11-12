import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ¡Importa el provider de Resumen!
import 'package:osito_polar_app/feature/provider-dashboard/presentation/providers/ProviderHomeProvider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/feature/provider-dashboard/presentation/widgets/ProviderDrawer.dart';

/// Pantalla Principal del Proveedor (Dashboard de Resumen).
class ProviderHomePage extends StatefulWidget {
  const ProviderHomePage({super.key});

  @override
  State<ProviderHomePage> createState() => _ProviderHomePageState();
}

class _ProviderHomePageState extends State<ProviderHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      // --- ¡AQUÍ ESTÁ EL ARREGLO! ---
      // Llamamos al método 'loadDashboardSummary' del nuevo provider
      context.read<ProviderHomeProvider>().loadDashboardSummary();

    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProviderHomeProvider>();
    final state = provider.state;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        // ... (Tu AppBar está bien)
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: AppColors.cardBorder,
        leading: Builder(
            builder: (BuildContext builderContext) {
              return IconButton(
                icon: const Icon(Icons.menu, color: AppColors.iconColor, size: 30),
                onPressed: () {
                  Scaffold.of(builderContext).openDrawer();
                },
              );
            }
        ),
        title: const Text('OsitoPolar', style: TextStyle(color: AppColors.logoColor, fontWeight: FontWeight.bold, fontSize: 24, fontFamily: 'Inter')),
        centerTitle: true,
      ),
      drawer: const ProviderDrawer(),
      body: _buildBody(context, provider, state),

      // --- ¡SIN BOTÓN FLOTANTE! ---
      // El botón '+' para añadir equipos ahora
      // vive en la página 'MyEquipmentPage'.
    );
  }

  /// Helper para construir el cuerpo de la pantalla según el estado
  Widget _buildBody(BuildContext context, ProviderHomeProvider provider, ProviderHomeState state) {
    switch (state) {
      case ProviderHomeState.initial:
      case ProviderHomeState.loading:
        return const Center(child: CircularProgressIndicator());
      case ProviderHomeState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error: ${provider.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontFamily: 'Inter'),
            ),
          ),
        );
      case ProviderHomeState.success:
      // --- ¡NUEVA UI! ---
      // Esta es la UI del Dashboard/Resumen
        return _buildDashboardContent(context, provider);
    }
  }

  // --- ¡UI DE RESUMEN COMPLETAMENTE NUEVA! ---
  Widget _buildDashboardContent(BuildContext context, ProviderHomeProvider provider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido, Provider', // (TODO: Poner el nombre real)
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: AppColors.title,
              ),
            ),
            const SizedBox(height: 24),

            // Tarjeta de Resumen de Equipos
            _buildSummaryCard(
              context,
              title: 'Mis Equipos',
              count: provider.equipmentCount,
              icon: Icons.kitchen,
              color: AppColors.primaryButton,
              routeName: '/provider_my_equipments', // (Navega a la pág. de equipos)
            ),
            const SizedBox(height: 16),

            // Tarjeta de Resumen de Marketplace
            _buildSummaryCard(
              context,
              title: 'Trabajos Disponibles',
              count: provider.marketplaceRequestCount,
              icon: Icons.work_history,
              color: Colors.green,
              routeName: '/provider_marketplace', // (Navega a la pág. de marketplace)
            ),

            // (Aquí podrías añadir más resúmenes...
            // ...como 'Clientes Activos' o 'Técnicos')
          ],
        ),
      ),
    );
  }

  // Helper para las tarjetas de resumen que SÍ navegan
  Widget _buildSummaryCard(
      BuildContext context, {
        required String title,
        required int count,
        required IconData icon,
        required Color color,
        required String routeName,
      }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, routeName),
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(icon, size: 50, color: color),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: AppColors.textColor),
            ],
          ),
        ),
      ),
    );
  }
}