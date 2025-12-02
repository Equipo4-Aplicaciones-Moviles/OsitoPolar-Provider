import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 // Para formatear fechas si es necesario
import 'package:osito_polar_app/core/theme/app_colors.dart';
// --- Providers y Entidades ---
import 'package:osito_polar_app/feature/service_request/presentation/providers/MarketplaceProvider.dart';
import 'package:osito_polar_app/feature/service_request/domain/entities/ServiceRequestEntity.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketplaceProvider>().loadMarketplaceData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketplaceProvider>();
    final state = provider.state;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: _buildBody(context, provider, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MarketplaceProvider provider, MarketplaceState state) {
    switch (state) {
      case MarketplaceState.initial:
      case MarketplaceState.loading:
        return const Center(child: CircularProgressIndicator(color: AppColors.primaryButton));
      case MarketplaceState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Error: ${provider.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontFamily: 'Inter'),
            ),
          ),
        );
      case MarketplaceState.success:
        return _buildMarketplaceContent(context, provider);
    }
  }

  Widget _buildMarketplaceContent(BuildContext context, MarketplaceProvider provider) {
    final requests = provider.serviceRequests;

    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_outline, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text("No hay trabajos disponibles.", style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mis servicios",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 10),

          // Filtros visuales (simulados por ahora para igualar diseño)
          Row(
            children: [
              _buildFilterChip("Mis trabajos", false),
              const SizedBox(width: 10),
              _buildFilterChip("Disponibles", true), // Activo
            ],
          ),
          const SizedBox(height: 20),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: requests.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _buildServiceRequestCard(context, provider, requests[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? Border.all(color: Colors.grey.shade200) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.black87 : Colors.grey,
        ),
      ),
    );
  }

  /// Tarjeta con diseño idéntico a la imagen (Barra lateral de color)
  Widget _buildServiceRequestCard(
      BuildContext context, MarketplaceProvider provider, ServiceRequestEntity request) {

    // 1. Determinar Color por Urgencia
    Color statusColor;
    switch (request.urgency.toLowerCase()) {
      case 'critical':
        statusColor = const Color(0xFFEF5350); // Rojo (como en la imagen)
        break;
      case 'high':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = const Color(0xFF4CAF50); // Verde
    }

    // 2. Formatear Fecha y Hora
    // Si la fecha es hoy, ponemos "Hoy", sino la fecha corta
    String dateText = "Fecha";
    if (request.scheduledDate != null) {
      final now = DateTime.now();
      final diff = request.scheduledDate!.difference(now).inDays;
      if (diff == 0 && request.scheduledDate!.day == now.day) {
        dateText = "Hoy";
      } else {
        dateText = "${request.scheduledDate!.day}/${request.scheduledDate!.month}";
      }
    }
    String timeText = request.timeSlot ?? "00:00";

    // 3. Subtítulo (Reemplazo del nombre del cliente que no tenemos)
    String subtitle = request.serviceType ?? "Cliente #${request.clientId}";

    return Container(
      height: 130, // Altura fija para que se vea uniforme
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // --- BARRA LATERAL DE COLOR ---
          Container(
            width: 12,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
          ),

          // --- CONTENIDO ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // COLUMNA 1: Fecha y Hora
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dateText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      Text(timeText, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),

                  const SizedBox(width: 24), // Separación

                  // COLUMNA 2: Info del Trabajo
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.title,
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, fontFamily: 'Inter'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle, // Aquí va el "Restaurante..." (o ServiceType)
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          request.serviceAddress ?? "Sin dirección",
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- BOTÓN ACEPTAR (Flotando a la derecha) ---
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: _isProcessing
                        ? null
                        : () => _showAcceptDialog(context, provider, request),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0277BD), // Azul "Aceptar"
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("Aceptar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showAcceptDialog(BuildContext context, MarketplaceProvider provider, ServiceRequestEntity request) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar'),
        content: Text('¿Aceptas el trabajo "${request.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() => _isProcessing = true);
              await provider.acceptServiceRequest(request.id);
              if (mounted) {
                await provider.loadMarketplaceData();
                setState(() => _isProcessing = false);
              }
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}