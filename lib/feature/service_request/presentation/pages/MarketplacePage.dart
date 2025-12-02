import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';

// Providers y Entidades
import 'package:osito_polar_app/feature/service_request/presentation/providers/MarketplaceProvider.dart';
import 'package:osito_polar_app/feature/service_request/domain/entities/ServiceRequestEntity.dart';
// Importamos Auth para saber QUIÉNES somos (nuestro ID)
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  bool _isProcessing = false;
  bool _showAvailable = true; // Simulación del filtro

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 10),
                Text('Error: ${provider.errorMessage}', textAlign: TextAlign.center),
                TextButton(onPressed: () => provider.loadMarketplaceData(), child: const Text("Reintentar"))
              ],
            ),
          ),
        );
      case MarketplaceState.success:
        return _buildMarketplaceContent(context, provider);
    }
  }

  Widget _buildMarketplaceContent(BuildContext context, MarketplaceProvider provider) {
    // Lista simulada para esta versión de rollback
    final requests = provider.serviceRequests;// Usamos availableRequests (la lista completa del Provider)

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
              _buildFilterChip("Mis trabajos", !_showAvailable, () => setState(() => _showAvailable = false)),
              const SizedBox(width: 10),
              _buildFilterChip("Disponibles", _showAvailable, () => setState(() => _showAvailable = true)), // Activo
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

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black87 : Colors.white, // Negro si activo, Blanco si inactivo
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
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
        statusColor = const Color(0xFFEF5350); // Rojo
        break;
      case 'high':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = const Color(0xFF4CAF50); // Verde
    }

    // 2. Formatear Fecha y Hora
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
    String subtitle = request.serviceType ?? "Cliente #${request.clientId}";

    // isMyJob es true cuando estamos en la pestaña "Mis trabajos" (usado para el botón)
    final isMyJob = !_showAvailable;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Usamos IntrinsicHeight y Row(crossAxisAlignment: CrossAxisAlignment.stretch)
      // para que la barra lateral crezca con el contenido.
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- BARRA LATERAL DE COLOR ---
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),

            // --- CONTENIDO PRINCIPAL ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // COLUMNA 1: Fecha y Hora (El ancho fijo ayuda a que el texto no desborde)
                    SizedBox(
                      width: 65, // Ancho fijo para "Hoy" y "14:00"
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dateText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(timeText, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ),

                    // Separación
                    const SizedBox(width: 16),

                    // COLUMNA 2: Info del Trabajo y Botón
                    Expanded( // Usamos Expanded para tomar el espacio restante
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Título y Subtítulo
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
                                      subtitle,
                                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                              ),
                              // Botón Aceptar/Detalle
                              SizedBox(
                                height: 32, // Altura fija
                                child: _buildActionButton(isMyJob, provider, request),
                              ),
                            ],
                          ),

                          // Dirección (Va abajo de la fila del botón)
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 12, color: Colors.grey[400]),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                    request.serviceAddress ?? "Sin dirección",
                                    style: TextStyle(color: Colors.grey[400], fontSize: 11),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget separado para manejar la lógica del botón Aceptar/Detalle
  Widget _buildActionButton(bool isMyJob, MarketplaceProvider provider, ServiceRequestEntity request) {
    if (!isMyJob) {
      return ElevatedButton(
        onPressed: _isProcessing
            ? null
            : () => _showAcceptDialog(context, provider, request),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryButton,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: const Text("Aceptar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      );
    } else {
      return OutlinedButton(
        onPressed: () {
          // Navegar a la pantalla de detalle de Work Order
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Navegar a detalle de trabajo"))
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryButton,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          side: const BorderSide(color: AppColors.primaryButton),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: const Text("Detalle", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      );
    }
  }

  void _showAcceptDialog(BuildContext context, MarketplaceProvider provider, ServiceRequestEntity request) {
    // Capturamos el Messenger ANTES de cualquier async
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Confirmar Trabajo'),
          content: Text('¿Estás seguro de que quieres aceptar el trabajo "${request.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryButton),
              onPressed: () async {
                Navigator.pop(ctx);
                setState(() => _isProcessing = true);

                final success = await provider.acceptServiceRequest(request.id);

                if (success) {
                  scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text("¡Trabajo aceptado con éxito!"), backgroundColor: Colors.green)
                  );
                  // Mover a "Mis trabajos" localmente
                  if (mounted) setState(() => _showAvailable = false);
                } else {
                  scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text("Error: ${provider.errorMessage}"), backgroundColor: Colors.red)
                  );
                  // Si falla, debemos recargar los datos para sincronizar con el servidor
                  if (mounted) provider.loadMarketplaceData();
                }

                if (mounted) setState(() => _isProcessing = false);
              },
              child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}