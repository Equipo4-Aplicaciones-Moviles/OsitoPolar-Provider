import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/feature/provider-dashboard/presentation/widgets/ProviderDrawer.dart';
// --- ¡Importamos el provider y la entidad correctos! ---
import 'package:osito_polar_app/feature/service_request/presentation/providers/MarketplaceProvider.dart';
import 'package:osito_polar_app/feature/service_request/domain/entities/ServiceRequestEntity.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  bool _isProcessing = false; // Bloquea los botones durante las peticiones

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // --- Carga las solicitudes del Marketplace al iniciar la página ---
      context.read<MarketplaceProvider>().loadMarketplaceData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- Observa el estado del MarketplaceProvider ---
    final provider = context.watch<MarketplaceProvider>();
    final state = provider.state;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: AppColors.cardBorder,
        leading: Builder(builder: (ctx) {
          return IconButton(
            icon: const Icon(Icons.menu, color: AppColors.iconColor, size: 30),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          );
        }),
        title: const Text(
          'Marketplace de Servicios', // Título de la página
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
      // --- Construye el cuerpo según el estado del provider ---
      body: _buildBody(context, provider, state),
    );
  }

  /// Construye el cuerpo principal de la página (indicadores de carga/error/éxito).
  Widget _buildBody(
      BuildContext context, MarketplaceProvider provider, MarketplaceState state) {
    switch (state) {
      case MarketplaceState.initial:
      case MarketplaceState.loading:
        return const Center(child: CircularProgressIndicator());
      case MarketplaceState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error al cargar solicitudes: ${provider.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontFamily: 'Inter'),
            ),
          ),
        );
      case MarketplaceState.success:
        return _buildMarketplaceContent(context, provider);
    }
  }

  /// Muestra la lista de solicitudes de servicio si la carga fue exitosa.
  Widget _buildMarketplaceContent(BuildContext context, MarketplaceProvider provider) {
    final requests = provider.serviceRequests;

    if (requests.isEmpty) {
      return Center(
        child: Card(
          elevation: 0,
          color: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: const BorderSide(color: AppColors.cardBorder, width: 1),
          ),
          margin: const EdgeInsets.all(16.0),
          child: const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'No hay trabajos disponibles en el Marketplace por ahora.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Inter', color: AppColors.textColor),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Trabajos Disponibles'),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // para que no haya doble scroll
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildServiceRequestCard(context, provider, request),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: AppColors.title,
        ),
      ),
    );
  }

  /// Construye una tarjeta para cada solicitud de servicio.
  Widget _buildServiceRequestCard(
      BuildContext context, MarketplaceProvider provider, ServiceRequestEntity request) {

    // Asumimos que una solicitud es "pendiente" si su estado es 'pending'
    final bool isPending = request.status.toLowerCase() == 'pending';

    return Card(
      elevation: 2,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.work_history, size: 30, color: AppColors.title),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    request.title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                // Icono de estado (opcional, si quieres un indicador visual)
                Icon(
                  isPending ? Icons.new_releases : Icons.check_circle,
                  color: isPending ? Colors.orange : Colors.green,
                  size: 24,
                ),
              ],
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (_isProcessing || !isPending)
                        ? null // Deshabilita si está procesando o no es pendiente
                        : () => _showAcceptDialog(context, provider, request),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPending ? Colors.green : Colors.grey,
                      foregroundColor: AppColors.buttonLabel,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Aceptar', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (_isProcessing || !isPending) ? null : () {
                      // TODO: Implementar lógica de "Denegar"
                      // Podrías mostrar un diálogo de confirmación aquí también.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Funcionalidad "Denegar" no implementada aún.')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPending ? Colors.red : Colors.grey,
                      foregroundColor: AppColors.buttonLabel,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Denegar', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Muestra un diálogo de confirmación para aceptar una solicitud de servicio.
  void _showAcceptDialog(
      BuildContext context, MarketplaceProvider provider, ServiceRequestEntity request) {
    final rootContext = context; // Para usarlo después del 'await'

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Aceptar Solicitud de Servicio'),
        content: Text('¿Estás seguro de que quieres aceptar el trabajo "${request.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar', style: TextStyle(color: AppColors.textColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: AppColors.buttonLabel,
            ),
            onPressed: () async {
              Navigator.pop(ctx); // Cierra el diálogo
              setState(() => _isProcessing = true); // Bloquea los botones

              final success = await provider.acceptServiceRequest(request.id);

              if (success && mounted) {
                // Si la operación fue exitosa, recarga los datos
                await provider.loadMarketplaceData();
              }

              if (mounted) {
                setState(() => _isProcessing = false); // Desbloquea los botones
              }

              if (rootContext.mounted) {
                ScaffoldMessenger.of(rootContext)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? '¡Solicitud "${request.title}" aceptada con éxito!'
                            : 'Error al aceptar: ${provider.errorMessage}',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
              }
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
