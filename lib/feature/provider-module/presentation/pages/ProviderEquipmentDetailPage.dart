import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/EquipmentDetailProvider.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/provider-dashboard/presentation/widgets/ProviderDrawer.dart';


/// Pantalla de Detalle de un Equipo Específico.
class ProviderEquipmentDetailPage extends StatefulWidget {
  const ProviderEquipmentDetailPage({super.key});

  @override
  State<ProviderEquipmentDetailPage> createState() =>
      _ProviderEquipmentDetailPageState();
}

class _ProviderEquipmentDetailPageState
    extends State<ProviderEquipmentDetailPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final equipmentId = ModalRoute.of(context)!.settings.arguments as int?;
      if (equipmentId != null) {
        context.read<EquipmentDetailProvider>().fetchEquipmentDetails(equipmentId);
      } else {
        print("Error: No se recibió equipmentId");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EquipmentDetailProvider>();
    final state = provider.state;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: AppColors.cardBorder,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, // Tu nuevo diseño no tiene flecha, pero es necesaria para la navegación
            color: AppColors.iconColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          // --- ¡TÍTULO MODIFICADO! ---
          'Mis Equipos - Clientes', // (Como en tu nueva imagen)
          style: TextStyle(
            color: AppColors.logoColor,
            fontWeight: FontWeight.bold,
            fontSize: 22, // Un poco más pequeño para que quepa
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: false, // El diseño lo alinea a la izquierda
        // --- ¡AÑADIDO! Botón de menú (¡está en tu nuevo diseño!) ---
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: AppColors.iconColor,
              size: 30,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
      // --- ¡AÑADIDO! Drawer (¡está en tu nuevo diseño!) ---
      drawer: const ProviderDrawer(),

      body: _buildBody(context, provider, state),
    );
  }

  /// Helper para construir el cuerpo de la pantalla según el estado
  Widget _buildBody(
      BuildContext context, EquipmentDetailProvider provider, EquipmentDetailState state) {
    switch (state) {
      case EquipmentDetailState.initial:
      case EquipmentDetailState.loading:
        return const Center(child: CircularProgressIndicator());
      case EquipmentDetailState.error:
        return Center(
          child: Text(
            'Error: ${provider.errorMessage}',
            style: const TextStyle(color: Colors.red, fontFamily: 'Inter'),
          ),
        );
      case EquipmentDetailState.success:
        if (provider.equipment == null) {
          return const Center(
            child: Text(
              'No se pudo cargar el equipo.',
              style: TextStyle(fontFamily: 'Inter'),
            ),
          );
        }
        // ¡Mostramos el nuevo diseño de detalle completo!
        return _buildDetailContent(context, provider.equipment!);
    }
  }

  // --- ¡HELPER RECONSTRUIDO! ---
  /// Este es el cuerpo real de la pantalla, que ahora es la
  /// de detalle completo basada en tu nuevo diseño (image_0aabff.png)
  Widget _buildDetailContent(BuildContext context, EquipmentEntity equipment) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Estira las tarjetas
          children: [
            // --- 1. TARJETA PRINCIPAL ---
            _buildMainInfoCard(context, equipment),
            const SizedBox(height: 24),

            // --- 2. SECCIÓN DE MONITOREO ---
            _buildSectionTitle(context, 'Monitoreo en tiempo real'),
            _buildRealtimeMonitoringCard(context, equipment),
            const SizedBox(height: 24),

            // --- 3. SECCIÓN DE TARJETAS PEQUEÑAS (GRID) ---
            // Usamos un Grid de 2 columnas
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true, // Necesario dentro de un SingleChildScrollView
              physics: const NeverScrollableScrollPhysics(), // El scroll lo maneja el SingleChildScrollView
              childAspectRatio: 1.5, // Ajusta esto para el tamaño de las tarjetas
              children: [
                _buildSmallDetailCard(
                  context: context,
                  title: 'Detalles técnicos',
                  icon: Icons.settings,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Modelo:', equipment.model),
                      _buildDetailRow('Marca:', equipment.manufacturer),
                      _buildDetailRow('Refrigerante:', equipment.refrigerant), // (Dato falso)
                    ],
                  ),
                ),
                _buildSmallDetailCard(
                  context: context,
                  title: 'Mantenimiento',
                  icon: Icons.build,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Último:', '15 Mar 2025'), // (Dato falso)
                      _buildDetailRow('Próximo:', '...'), // (Dato falso)
                    ],
                  ),
                ),
                _buildSmallDetailCard(
                  context: context,
                  title: 'Estado del sistema',
                  icon: Icons.check_circle_outline,
                  iconColor: Colors.green,
                  content: Text(
                    equipment.status, // "Operativo"
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ),
                _buildSmallDetailCard(
                  context: context,
                  title: 'Notas',
                  icon: Icons.note_alt,
                  content: Text(
                    equipment.notes, // (De la API)
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 12),
                  ),
                ),
              ],
            ),
            // (Añadimos espacio al final para el footer)
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  /// Helper: Tarjeta Principal (con imagen, serie, código, ubicación)
  Widget _buildMainInfoCard(BuildContext context, EquipmentEntity equipment) {
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
            _buildSectionTitle(context, 'Mis equipos'),
            const SizedBox(height: 16),
            // Imagen
            Container(
              width: 100,
              height: 130,
              decoration: BoxDecoration(
                color: AppColors.textFieldBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Icon(Icons.kitchen_outlined, color: AppColors.textColor, size: 60),
            ),
            const SizedBox(height: 8),
            Text(
              equipment.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.cardBorder),
            const SizedBox(height: 16),
            // Detalles (Serie, Código, Ubicación)
            _buildDetailRow('Serie:', equipment.serialNumber),
            _buildDetailRow('Código:', equipment.code),
            _buildDetailRow('Ubicación física:', equipment.locationName),
          ],
        ),
      ),
    );
  }

  /// Helper: Tarjeta de Monitoreo (Consumo, Temp, Voltaje)
  Widget _buildRealtimeMonitoringCard(BuildContext context, EquipmentEntity equipment) {
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
            _buildMonitoringRow(
                context,
                icon: Icons.flash_on,
                label: 'Consumo de energía',
                value: '${equipment.energyConsumptionCurrent.toStringAsFixed(0)} W'
            ),
            const Divider(color: AppColors.cardBorder),
            _buildMonitoringRow(
                context,
                icon: Icons.thermostat,
                label: 'Temperatura',
                value: '${equipment.currentTemperature.toStringAsFixed(0)} °C'
            ),
            const Divider(color: AppColors.cardBorder),
            _buildMonitoringRow(
                context,
                icon: Icons.electrical_services,
                label: 'Voltaje',
                value: equipment.voltage // (Dato falso)
            ),
          ],
        ),
      ),
    );
  }

  /// Helper: Tarjetas Pequeñas (Detalles, Mantenimiento, etc.)
  Widget _buildSmallDetailCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget content,
    Color iconColor = AppColors.title,
  }) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila de Título
            Row(
              children: [
                Icon(icon, color: iconColor, size: 16),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.title,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Contenido
            Expanded(
              child: content,
            ),
          ],
        ),
      ),
    );
  }

  /// Helper para construir los títulos de sección (ej. "Monitoreo...")
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: AppColors.title,
        ),
      ),
    );
  }

  /// Helper para una fila de detalle (ej. "Serie: 12345")
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.textColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper para una fila de monitoreo (ej. "Icono | Temperatura | -18°C")
  Widget _buildMonitoringRow(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icono y Etiqueta
          Row(
            children: [
              Icon(icon, color: AppColors.title, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          // Valor
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: AppColors.textFieldBackground, // Fondo gris claro
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder)
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}