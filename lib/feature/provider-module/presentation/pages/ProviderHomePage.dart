import 'package:flutter/material.dart';
// 1. IMPORTAMOS EL NUEVO PROVIDER Y EL PAQUETE 'provider'
import 'package:osito_polar_app/feature/provider-dashboard/presentation/providers/ProviderHomeProvider.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:provider/provider.dart';

import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/feature/provider-dashboard/presentation/widgets/ProviderDrawer.dart';

/// Pantalla Principal del Proveedor (Empresa).
///
/// 2. LO CONVERTIMOS EN UN STATEFULWIDGET
///    para poder llamar a la API en initState()
class ProviderHomePage extends StatefulWidget {
  const ProviderHomePage({super.key});

  @override
  State<ProviderHomePage> createState() => _ProviderHomePageState();
}

class _ProviderHomePageState extends State<ProviderHomePage> {
  // 3. LLAMAMOS A LA API CUANDO LA PANTALLA SE CONSTRUYE
  @override
  void initState() {
    super.initState();
    // Usamos addPostFrameCallback para asegurarnos de que el 'context'
    // esté listo antes de llamar al Provider.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Usamos 'read' (listen: false) dentro de initState
      context.read<ProviderHomeProvider>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 4. "OBSERVAMOS" EL ESTADO DEL PROVIDER
    //    'watch' hace que la UI se reconstruya cuando el Provider
    //    llama a notifyListeners()
    final provider = context.watch<ProviderHomeProvider>();
    final state = provider.state;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
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
      drawer: const ProviderDrawer(),
      // 5. CONSTRUIMOS EL CUERPO BASADO EN EL ESTADO
      body: _buildBody(context, provider, state),
    );
  }

  /// Helper para construir el cuerpo de la pantalla según el estado
  Widget _buildBody(BuildContext context, ProviderHomeProvider provider, ProviderHomeState state) {
    // 6. MANEJAMOS LOS ESTADOS DE CARGA Y ERROR
    switch (state) {
      case ProviderHomeState.initial:
      case ProviderHomeState.loading:
      // Muestra un spinner mientras carga
        return const Center(child: CircularProgressIndicator());
      case ProviderHomeState.error:
      // Muestra un mensaje de error si la API falla
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error: ${provider.errorMessage}\n\n'
                  '(Asegúrate de que el back-end esté corriendo y que la URL en '
                  'EquipmentRemoteDataSourceImpl.dart sea correcta. '
                  'Recuerda que esta llamada necesita un Token de Auth que aún no estamos enviando.)',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontFamily: 'Inter'),
            ),
          ),
        );
      case ProviderHomeState.success:
      // Muestra el contenido si todo salió bien
        return _buildDashboardContent(context, provider);
    }
  }

  /// El contenido del dashboard (lo que ya teníamos)
  Widget _buildDashboardContent(BuildContext context, ProviderHomeProvider provider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECCIÓN: MIS EQUIPOS (¡AHORA CON DATOS REALES!) ---
            _buildSectionTitle(context, 'Mis equipos'),
            const SizedBox(height: 8),
            // 7. LLAMAMOS AL NUEVO HELPER DE LISTA
            _buildEquipmentList(context, provider.equipments),
            const SizedBox(height: 24),

            // --- SECCIÓN: MANTENIMIENTOS (Aún con datos falsos) ---
            _buildSectionTitle(context, 'Mantenimientos'),
            const SizedBox(height: 8),
            _buildMaintenanceCard(context),
            const SizedBox(height: 24),

            // --- SECCIÓN: SOLICITUDES (Aún con datos falsos) ---
            _buildSectionTitle(context, 'Solicitudes'),
            const SizedBox(height: 8),
            _buildRequestCard(context),
            const SizedBox(height: 24),

            // --- SECCIÓN: ESTADOS DE CUENTA (Aún con datos falsos) ---
            _buildSectionTitle(context, 'Estados de cuenta'),
            const SizedBox(height: 8),
            _buildAccountStatusCard(context),
          ],
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

  // --- 8. WIDGET DE LISTA DE EQUIPOS (¡NUEVO!) ---
  Widget _buildEquipmentList(BuildContext context, List<EquipmentEntity> equipments) {
    if (equipments.isEmpty) {
      // Muestra un mensaje si la API no devuelve nada
      return Card(
        elevation: 0,
        color: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No se encontraron equipos.',
              style: TextStyle(fontFamily: 'Inter', color: AppColors.textColor),
            ),
          ),
        ),
      );
    }

    // Usamos ListView.builder para construir la lista dinámicamente
    return ListView.builder(
      itemCount: equipments.length,
      shrinkWrap: true, // Necesario dentro de un SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(), // El scroll lo maneja el SingleChildScrollView
      itemBuilder: (context, index) {
        final equipment = equipments[index];
        // Reutilizamos nuestra tarjeta, pero ahora le pasamos datos reales
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: _buildEquipmentCard(context, equipment),
        );
      },
    );
  }

  /// --- 9. TARJETA DE EQUIPO (MODIFICADA) ---
  /// Ahora acepta un [EquipmentEntity] con los datos reales
  Widget _buildEquipmentCard(BuildContext context, EquipmentEntity equipment) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Pasar el 'equipment.id' a la página de detalle
          Navigator.pushNamed(context, '/provider_equipment_detail');
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- ¡DATOS REALES! ---
                    Text(
                      equipment.name, // <-- Nombre real
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'S/N: ${equipment.serialNumber}', // <-- Serial real
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
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

  // ... (El resto de helpers para Mantenimiento, Solicitudes y Cuentas
  //      siguen siendo los mismos por ahora, con datos falsos) ...

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