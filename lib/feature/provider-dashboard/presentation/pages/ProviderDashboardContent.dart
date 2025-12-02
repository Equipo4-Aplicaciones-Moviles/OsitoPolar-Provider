import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';

// Importamos el Provider de datos del Dashboard
import 'package:osito_polar_app/feature/provider-dashboard/presentation/providers/ProviderHomeProvider.dart';
// Importamos el Provider de Login para sacar el nombre del usuario
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';

class ProviderDashboardContent extends StatefulWidget {
  // CORRECCIÓN: El constructor debe ser simple, SIN pedir 'context'
  const ProviderDashboardContent({super.key});

  @override
  State<ProviderDashboardContent> createState() => _ProviderDashboardContentState();
}

class _ProviderDashboardContentState extends State<ProviderDashboardContent> {

  @override
  void initState() {
    super.initState();
    // Cargamos los datos del resumen cada vez que se inicia este widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProviderHomeProvider>().loadDashboardSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Consumimos el estado del Provider Home
    final provider = context.watch<ProviderHomeProvider>();
    final state = provider.state;

    // Obtenemos el nombre del usuario desde el LoginProvider
    final user = context.watch<ProviderLoginProvider>().user;
    final String userName = user?.username ?? "Provider";

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      // AppBar propia del Dashboard
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // --- CAMBIO CLAVE: QUITAMOS EL DRAWER ---
        automaticallyImplyLeading: false, // Esto evita que salga la flecha atrás o el menú
        // Ya no ponemos "leading: IconButton(...)"

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "Bienvenido,",
                style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.normal)
            ),
            Text(
                userName,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      // --- CAMBIO CLAVE: QUITAMOS EL DRAWER ---
      // drawer: const ProviderDrawer(), // <--- ESTO SE BORRÓ

      body: _buildBody(context, provider, state),
    );
  }

  /// Construye el cuerpo según el estado (Cargando, Error, Éxito)
  Widget _buildBody(BuildContext context, ProviderHomeProvider provider, ProviderHomeState state) {
    switch (state) {
      case ProviderHomeState.initial:
      case ProviderHomeState.loading:
        return const Center(child: CircularProgressIndicator(color: AppColors.primaryButton));

      case ProviderHomeState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'No se pudo cargar el resumen.\n${provider.errorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadDashboardSummary(),
                  child: const Text("Reintentar"),
                )
              ],
            ),
          ),
        );

      case ProviderHomeState.success:
        return _buildDashboardContent(context, provider);
    }
  }

  // --- UI DE RESUMEN (Versión corregida y limpia) ---
  Widget _buildDashboardContent(BuildContext context, ProviderHomeProvider provider) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen General',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 28, // Tamaño grande como antes
              color: AppColors.title,
            ),
          ),
          const SizedBox(height: 24),

          // Tarjeta 1: Mis Equipos (Diseño ancho original)
          _buildSummaryCard(
            context,
            title: 'Mis Equipos',
            count: provider.equipmentCount,
            icon: Icons.kitchen,
            color: AppColors.primaryButton,
            onTap: () {
              // Aquí podrías navegar si quisieras, pero ya tienes la barra inferior
            },
          ),

          const SizedBox(height: 16),

          // Tarjeta 2: Marketplace (Diseño ancho original)
          _buildSummaryCard(
            context,
            title: 'Trabajos Disponibles',
            count: provider.marketplaceRequestCount,
            icon: Icons.work_history,
            color: Colors.green,
            onTap: () {},
          ),

          // (Se eliminó la sección de Gestión Rápida para evitar overflow y ruido visual)
        ],
      ),
    );
  }

  // Helper para las tarjetas de resumen (Estilo original recuperado)
  Widget _buildSummaryCard(
      BuildContext context, {
        required String title,
        required int count,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(icon, size: 50, color: color), // Icono grande
              const SizedBox(width: 24),
              Expanded( // Expanded evita overflow de texto
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      count.toString(),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.black87,
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
              ),
              const Icon(Icons.arrow_forward_ios, color: AppColors.textColor),
            ],
          ),
        ),
      ),
    );
  }
}