import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';

// Provider y Entidades
import 'package:osito_polar_app/feature/equipment/presentation/providers/EquipmentDetailProvider.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
// Descomentamos esto para que funcione la sección de salud
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
    // Cargar datos al entrar a la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EquipmentDetailProvider>().fetchEquipmentDetails(widget.equipmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EquipmentDetailProvider>();
    final state = provider.state;
    final equipment = provider.equipment;

    // --- 🔍 DEBUG LOG: VERIFICAR DATOS REALES ---
    if (equipment != null) {
      print("--------------------------------------------------");
      print("🔍 DEBUG: Datos del Equipo (ID: ${equipment.id})");
      print("   -> Nombre: ${equipment.name}");
      print("   -> Status (Crudo): '${equipment.status}'");
      print("   -> Temp. Actual (Sensor): ${equipment.currentTemperature}");
      print("   -> Temp. Objetivo (Set): ${equipment.setTemperature}");
      print("   -> ¿Está Encendido?: ${equipment.isPoweredOn}");
      print("--------------------------------------------------");
    }
    // --------------------------------------------------------

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Fondo gris suave para contraste
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. HEADER (Botón Atrás y Título) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  _buildBackButton(context),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "Detalle del Equipo",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                        fontFamily: 'Inter',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Botón de Refrescar
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.black54),
                    onPressed: () => provider.fetchEquipmentDetails(widget.equipmentId),
                  )
                ],
              ),
            ),

            // --- 2. CONTENIDO PRINCIPAL ---
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
    // Loading inicial
    if (state == EquipmentDetailState.loading && equipment == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryButton));
    }

    // Error
    if (state == EquipmentDetailState.error || equipment == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(provider.errorMessage, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.fetchEquipmentDetails(widget.equipmentId),
              child: const Text("Reintentar"),
            )
          ],
        ),
      );
    }

    // --- VISTA DE DETALLE ---
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. TARJETA PRINCIPAL (Sin controles de edición)
          _buildMainControlCard(equipment, provider),

          const SizedBox(height: 24),

          // 2. SALUD DEL EQUIPO (Analítica)
          const Text(
            "Salud del Equipo",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 12),
          _buildHealthSection(provider),

          const SizedBox(height: 24),

          // 3. ESPECIFICACIONES TÉCNICAS
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

  Widget _buildMainControlCard(EquipmentEntity eq, EquipmentDetailProvider provider) {
    // Lógica de estado basada en String (active, inactive, etc.)
    final String status = eq.status.toLowerCase();

    Color chipColor = Colors.grey.shade100;
    Color textColor = Colors.grey;
    IconData statusIcon = Icons.help_outline;
    String label = "DESCONOCIDO";

    if (status == 'active') {
      chipColor = const Color(0xFFE8F5E9);
      textColor = Colors.green;
      statusIcon = Icons.check_circle;
      label = "ACTIVO";
    } else if (status == 'maintenance') {
      chipColor = const Color(0xFFFFF3E0);
      textColor = Colors.orange;
      statusIcon = Icons.build;
      label = "MANTENIMIENTO";
    } else if (status == 'inactive' || status == 'outofservice') {
      chipColor = const Color(0xFFFFEBEE);
      textColor = Colors.red;
      statusIcon = Icons.error;
      label = "INACTIVO";
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          // INFO SUPERIOR
          Row(
            children: [
              Container(
                height: 70, width: 70,
                decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.kitchen, size: 36, color: AppColors.primaryButton),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(eq.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text("${eq.model} • ${eq.manufacturer}", style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: chipColor, borderRadius: BorderRadius.circular(6)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 12, color: textColor),
                          const SizedBox(width: 4),
                          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Divider(),
          ),

          // --- INFO DE TERMOSTATO (MODO LECTURA) ---
          // Como la API devuelve 403, quitamos los botones + / -
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Termostato", style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Text("Configuración Actual", style: TextStyle(fontSize: 12, color: Colors.black45)),
                ],
              ),

              // VISUALIZADOR DE TEMPERATURA
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Text(
                    "${eq.setTemperature?.toStringAsFixed(1) ?? '--'}°C",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87)
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHealthSection(EquipmentDetailProvider provider) {
    if (provider.isHealthLoading) {
      return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
    }
    final health = provider.healthMetrics;
    if (health == null) {
      return _buildErrorCard("No hay datos de salud disponibles por el momento.");
    }

    // Colores dinámicos
    Color scoreColor = Colors.green;
    if (health.overallScore < 80) scoreColor = Colors.orange;
    if (health.overallScore < 50) scoreColor = Colors.red;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scoreColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60, height: 60,
                child: CircularProgressIndicator(
                  value: health.overallScore / 100,
                  color: scoreColor,
                  backgroundColor: Colors.grey.shade100,
                  strokeWidth: 6,
                ),
              ),
              Text("${health.overallScore.toInt()}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: scoreColor)),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Estado: ${health.status}", style: TextStyle(fontWeight: FontWeight.bold, color: scoreColor, fontSize: 16)),
                const SizedBox(height: 4),
                Text(health.recommendation, style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
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
      childAspectRatio: 1.6, // Más ancho que alto
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildSpecItem(Icons.thermostat, "Temperatura Actual", "${eq.currentTemperature}°C"),
        _buildSpecItem(Icons.qr_code, "Serie", eq.serialNumber),
        _buildSpecItem(Icons.location_on, "Ubicación", eq.locationName),
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
          Icon(icon, size: 20, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String msg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        const Icon(Icons.info_outline, color: Colors.orange),
        const SizedBox(width: 10),
        Expanded(child: Text(msg, style: TextStyle(color: Colors.orange.shade800, fontSize: 12)))
      ]),
    );
  }
}