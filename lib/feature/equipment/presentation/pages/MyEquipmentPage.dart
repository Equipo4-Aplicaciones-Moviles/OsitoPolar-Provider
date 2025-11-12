import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// --- ¡MODIFICADO! ---
// Borramos ProviderHomeProvider e importamos el provider correcto
import 'package:osito_polar_app/feature/equipment/presentation/providers/EquipmentProvider.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/feature/provider-dashboard/presentation/widgets/ProviderDrawer.dart';
// (Ya no necesitamos ServiceRequestEntity aquí)

class MyEquipmentPage extends StatefulWidget {
  const MyEquipmentPage({super.key});

  @override
  State<MyEquipmentPage> createState() => _MyEquipmentPageState();
}

class _MyEquipmentPageState extends State<MyEquipmentPage> {
  bool _isProcessing = false; // 🔒 bloquea botones durante peticiones

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // --- ¡MODIFICADO! ---
      // Llama al método correcto del provider correcto
      context.read<EquipmentProvider>().loadEquipments();
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- ¡MODIFICADO! ---
    final provider = context.watch<EquipmentProvider>();
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
          'Mis Equipos', // <-- ¡Título actualizado!
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
      body: _buildBody(context, provider, state),
      floatingActionButton: FloatingActionButton(
        onPressed: _isProcessing
            ? null
            : () async {
          await Navigator.pushNamed(context, '/provider_add_equipment');
          if (mounted) {
            // --- ¡MODIFICADO! ---
            context.read<EquipmentProvider>().loadEquipments();
          }
        },
        backgroundColor: AppColors.primaryButton,
        foregroundColor: AppColors.buttonLabel,
        tooltip: 'Añadir Equipo',
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- ¡MODIFICADO! ---
  Widget _buildBody(
      BuildContext context, EquipmentProvider provider, EquipmentState state) {
    switch (state) {
      case EquipmentState.initial:
      case EquipmentState.loading:
        return const Center(child: CircularProgressIndicator());
      case EquipmentState.error:
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
      case EquipmentState.success:
        return _buildDashboardContent(context, provider);
    }
  }

  // --- ¡MODIFICADO! ---
  Widget _buildDashboardContent(
      BuildContext context, EquipmentProvider provider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Mi Inventario'), // <-- Título actualizado
            const SizedBox(height: 8),
            _buildEquipmentList(context, provider),
            const SizedBox(height: 80), // Espacio para el FAB

            // --- ¡BORRADO! ---
            // La sección 'Marketplace de Servicios' ya no va aquí.
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    // ... (Tu código de _buildSectionTitle está perfecto)
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

  // --- ¡MODIFICADO! ---
  Widget _buildEquipmentList(
      BuildContext context, EquipmentProvider provider) {
    // ... (Tu código de _buildEquipmentList está perfecto)
    final equipments = provider.equipments;
    if (equipments.isEmpty) {
      return Card(
        elevation: 0,
        color: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No se encontraron equipos. ¡Añade uno con el botón +!',
              style: TextStyle(fontFamily: 'Inter', color: AppColors.textColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 480,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: equipments.length,
        itemBuilder: (context, index) {
          final equipment = equipments[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildEquipmentCard(context, provider, equipment),
          );
        },
      ),
    );
  }

  // --- ¡MODIFICADO! ---
  Widget _buildEquipmentCard(
      BuildContext context, EquipmentProvider provider, EquipmentEntity eq) {
    // ... (Tu código de _buildEquipmentCard está perfecto)
    final statusColor =
    (eq.status.toLowerCase() == 'active' || eq.status.toLowerCase() == 'normal')
        ? Colors.green
        : Colors.red;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.power_settings_new, color: Colors.green, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(eq.name,
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      Text('${eq.type} ${eq.model}',
                          style:
                          const TextStyle(fontFamily: 'Inter', fontSize: 14)),
                    ],
                  ),
                ),
                CircleAvatar(radius: 8, backgroundColor: statusColor),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.textFieldBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Icon(Icons.kitchen_outlined,
                  color: AppColors.textColor, size: 60),
            ),
            const SizedBox(height: 16),
            Text('${eq.currentTemperature.toStringAsFixed(0)}°',
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 50)),
            Text('(${eq.status})',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 16)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.textFieldBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, size: 18),
                  const SizedBox(width: 8),
                  Text(eq.locationName,
                      style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing
                        ? null
                        : () => _showPublishDialog(context, provider, eq),
                    icon: const Icon(Icons.public, size: 16),
                    label: const Text('Publicar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    icon: const Icon(Icons.public_off, size: 20),
                    onPressed: _isProcessing
                        ? null
                        : () => _showUnpublishDialog(context, provider, eq),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: _isProcessing
                        ? null
                        : () => _showDeleteDialog(context, provider, eq),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- ¡MODIFICADO! ---
  // (El provider ahora es 'EquipmentProvider')
  void _showDeleteDialog(
      BuildContext context, EquipmentProvider provider, EquipmentEntity eq) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Borrado'),
        content: Text('¿Borrar "${eq.name}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Borrar'),
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() => _isProcessing = true);
              final success = await provider.deleteEquipment(eq.id);
              if (success && mounted) {
                await provider.loadEquipments(); // <-- ¡Llama al método correcto!
              }
              setState(() => _isProcessing = false);
              if (!mounted) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(success
                      ? '¡Equipo "${eq.name}" borrado!'
                      : 'Error: ${provider.errorMessage}'),
                  backgroundColor: success ? Colors.green : Colors.red,
                ));
            },
          ),
        ],
      ),
    );
  }

  // --- ¡MODIFICADO! ---
  // (El provider ahora es 'EquipmentProvider')
  void _showPublishDialog(
      BuildContext context, EquipmentProvider provider, EquipmentEntity eq) {
    final priceController = TextEditingController(text: '100.00');
    final rootContext = context;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Publicar Equipo'),
        content: TextField(
          controller: priceController,
          decoration: const InputDecoration(
            labelText: 'Precio mensual (USD)',
            prefixIcon: Icon(Icons.attach_money),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              final price = double.tryParse(priceController.text);
              if (price == null || price <= 0) return;
              Navigator.pop(ctx); // Cierra el diálogo
              setState(() => _isProcessing = true);

              final success = await provider.publishEquipment(eq.id, price);
              if (success && mounted) {
                await provider.loadEquipments(); // <-- ¡Llama al método correcto!
              }

              if (!mounted) return;
              setState(() => _isProcessing = false);

              if (rootContext.mounted) {
                ScaffoldMessenger.of(rootContext)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text(success
                        ? '¡"${eq.name}" publicado exitosamente!'
                        : 'Error: ${provider.errorMessage}'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ));
              }
            },
            child: const Text('Publicar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- ¡MODIFICADO! ---
  // (El provider ahora es 'EquipmentProvider')
  void _showUnpublishDialog(
      BuildContext context, EquipmentProvider provider, EquipmentEntity eq) {
    final rootContext = context;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocultar Equipo'),
        content: Text('¿Ocultar "${eq.name}" del marketplace?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            child: const Text('Ocultar', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() => _isProcessing = true);
              final success = await provider.unpublishEquipment(eq.id);

              // (Tu lógica de 'contains' está bien)
              if (success || provider.errorMessage.contains('not published for rent')) {
                if (mounted) await provider.loadEquipments(); // <-- ¡Llama al método correcto!
              }

              setState(() => _isProcessing = false);

              if (rootContext.mounted) {
                ScaffoldMessenger.of(rootContext)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text(
                      (success || provider.errorMessage.contains('not published for rent'))
                          ? '¡"${eq.name}" ocultado!'
                          : 'Error: ${provider.errorMessage}',
                    ),
                    backgroundColor: (success || provider.errorMessage.contains('not published for rent'))
                        ? Colors.green
                        : Colors.red,
                  ));
              }
            },
          ),
        ],
      ),
    );
  }

// --- ¡BORRADO! ---
// (Los métodos _buildMaintenanceList, _buildMaintenanceCard, y _showAcceptDialog
//  ya no están en esta página).
}