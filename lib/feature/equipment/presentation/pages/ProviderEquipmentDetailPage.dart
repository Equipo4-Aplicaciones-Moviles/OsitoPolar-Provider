import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';

// Provider y Entidades
import 'package:osito_polar_app/feature/equipment/presentation/providers/EquipmentDetailProvider.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentHealthEntity.dart';

class ProviderEquipmentDetailPage extends StatefulWidget {
  final int equipmentId;

  const ProviderEquipmentDetailPage({super.key, required this.equipmentId});

  @override
  State<ProviderEquipmentDetailPage> createState() => _ProviderEquipmentDetailPageState();
}

class _ProviderEquipmentDetailPageState extends State<ProviderEquipmentDetailPage> {

  @override
  void initState() {
    super.initState();
    // Cargar datos al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EquipmentDetailProvider>().fetchEquipmentDetails(widget.equipmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EquipmentDetailProvider>();
    final state = provider.state;
    final equipment = provider.equipment;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Fondo gris suave
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. HEADER PERSONALIZADO ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  _buildBackButton(context),
                  const SizedBox(width: 16),
                  const Text(
                    "Detalle del Equipo",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const Spacer(),
                  // Botón de Editar (Opcional)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.black54),
                    onPressed: () {
                      // Navegar a editar
                    },
                  )
                ],
              ),
            ),

            // --- 2. CONTENIDO ---
            Expanded(
              child: _buildBody(provider, state, equipment),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Icon(Icons.arrow_back, size: 20, color: Colors.black87),
      ),
    );
  }

  Widget _buildBody(EquipmentDetailProvider provider, EquipmentDetailState state, EquipmentEntity? equipment) {
    if (state == EquipmentDetailState.loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryButton));
    }

    if (state == EquipmentDetailState.error || equipment == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(provider.errorMessage, style: const TextStyle(color: Colors.grey)),
            TextButton(
              onPressed: () => provider.fetchEquipmentDetails(widget.equipmentId),
              child: const Text("Reintentar"),
            )
          ],
        ),
      );
    }

    // --- SI HAY DATOS, MOSTRAMOS EL DETALLE ---
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. TARJETA PRINCIPAL (Info Básica)
          _buildMainInfoCard(equipment),

          const SizedBox(height: 24),

          // 2. SECCIÓN DE SALUD (Analytics)
          const Text(
            "Salud del Equipo",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 12),
          _buildHealthSection(provider),

          const SizedBox(height: 24),

          // 3. DETALLES TÉCNICOS (Grid)
          const Text(
            "Especificaciones",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 12),
          _buildSpecsGrid(equipment),
        ],
      ),
    );
  }

  Widget _buildMainInfoCard(EquipmentEntity eq) {
    // --- LÓGICA DE ESTADO CORREGIDA ---
    // Usamos eq.status (String) en lugar de isPoweredOn
    final String status = eq.status?.toLowerCase() ?? "inactive";

    Color chipColor;
    Color textColor;
    IconData icon;
    String label;

    switch (status) {
      case 'active':
        chipColor = const Color(0xFFE8F5E9); // Verde claro
        textColor = Colors.green[700]!;
        icon = Icons.check_circle;
        label = "ACTIVO";
        break;
      case 'maintenance':
        chipColor = const Color(0xFFFFF3E0); // Naranja claro
        textColor = Colors.orange[800]!;
        icon = Icons.build;
        label = "MANTENIMIENTO";
        break;
      case 'outofservice':
        chipColor = const Color(0xFFFFEBEE); // Rojo claro
        textColor = Colors.red[700]!;
        icon = Icons.error;
        label = "FUERA DE SERVICIO";
        break;
      case 'inactive':
      default:
        chipColor = const Color(0xFFF5F5F5); // Gris claro
        textColor = Colors.grey[700]!;
        icon = Icons.power_off;
        label = "INACTIVO";
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          // Icono Grande
          Container(
            height: 80, width: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD), // Azul muy claro
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.kitchen, size: 40, color: AppColors.primaryButton),
          ),
          const SizedBox(width: 20),

          // Textos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eq.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, height: 1.2),
                ),
                const SizedBox(height: 6),
                Text(
                  "${eq.model ?? 'Sin modelo'} • ${eq.manufacturer ?? 'Generico'}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),

                // Chip de Estado (Con lógica de Status)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: chipColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 14, color: textColor),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: textColor
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHealthSection(EquipmentDetailProvider provider) {
    if (provider.isHealthLoading) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(strokeWidth: 2),
      ));
    }

    final health = provider.healthMetrics;

    if (health == null) {
      return _buildErrorCard("No hay datos de salud disponibles.");
    }

    // Determinar colores según el score
    Color scoreColor = Colors.green;
    if (health.overallScore < 80) scoreColor = Colors.orange;
    if (health.overallScore < 50) scoreColor = Colors.red;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scoreColor.withOpacity(0.2), width: 1),
        boxShadow: [BoxShadow(color: scoreColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Puntaje de Salud", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                      health.status.toUpperCase(),
                      style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                ],
              ),
              // Círculo de puntaje
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 60, width: 60,
                    child: CircularProgressIndicator(
                      value: health.overallScore / 100,
                      color: scoreColor,
                      backgroundColor: Colors.grey.shade100,
                      strokeWidth: 6,
                    ),
                  ),
                  Text(
                    "${health.overallScore.toInt()}",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: scoreColor),
                  )
                ],
              )
            ],
          ),
          const Divider(height: 30),
          // Recomendación
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  health.recommendation,
                  style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSpecsGrid(EquipmentEntity eq) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildSpecItem(Icons.thermostat, "Temperatura", "${eq.currentTemperature}°C"),
        _buildSpecItem(Icons.qr_code, "Serie", eq.serialNumber ?? "N/A"),
        _buildSpecItem(Icons.location_on_outlined, "Ubicación", eq.locationName ?? "N/A"),
        _buildSpecItem(Icons.bolt, "Energía", "${eq.energyConsumptionCurrent} ${eq.energyConsumptionCurrent}"),
      ],
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String msg) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Text(msg, style: TextStyle(color: Colors.red.shade700), textAlign: TextAlign.center),
    );
  }
}