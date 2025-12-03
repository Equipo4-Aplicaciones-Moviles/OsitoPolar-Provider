import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:osito_polar_app/core/theme/app_colors.dart';
// import 'package:osito_polar_app/feature/provider-dashboard/presentation/widgets/ProviderDrawer.dart'; // Ya no se usa Drawer aquí
import 'package:osito_polar_app/feature/equipment/presentation/providers/EquipmentProvider.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';

class MyEquipmentPage extends StatefulWidget {
  const MyEquipmentPage({super.key});

  @override
  State<MyEquipmentPage> createState() => _MyEquipmentPageState();
}

class _MyEquipmentPageState extends State<MyEquipmentPage> {
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EquipmentProvider>().loadEquipments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EquipmentProvider>();
    final state = provider.state;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Fondo gris claro

      // Usamos SafeArea para que el título no choque con la barra de notificaciones
      body: SafeArea(
        child: _buildBody(context, provider, state),
      ),

      floatingActionButton: FloatingActionButton(
        // Tag único para evitar conflicto con el FAB del Dashboard si están en IndexedStack
        heroTag: 'addEquipmentTag',
        onPressed: _isProcessing
            ? null
            : () async {
          await Navigator.pushNamed(context, '/provider_add_equipment');
          if (mounted) {
            context.read<EquipmentProvider>().loadEquipments();
          }
        },
        backgroundColor: AppColors.primaryButton,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }

  Widget _buildBody(BuildContext context, EquipmentProvider provider, EquipmentState state) {
    if (state == EquipmentState.loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryButton));
    }
    if (state == EquipmentState.error) {
      return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Error: ${provider.errorMessage}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          )
      );
    }
    return _buildDashboardContent(context, provider);
  }

  Widget _buildDashboardContent(BuildContext context, EquipmentProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- TÍTULO PRINCIPAL ---
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
          child: Text(
            "Mis equipos",
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                fontFamily: 'Inter'
            ),
          ),
        ),

        Expanded(
          child: provider.equipments.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: provider.equipments.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 16),
            itemBuilder: (ctx, i) => _buildEquipmentCard(provider.equipments[i], provider),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
              "No tienes equipos registrados.",
              style: TextStyle(color: Colors.grey[600], fontSize: 16)
          ),
        ],
      ),
    );
  }

  // --- TARJETA IDÉNTICA A LA IMAGEN CON NAVEGACIÓN ---
  Widget _buildEquipmentCard(EquipmentEntity eq, EquipmentProvider provider) {

    // Estado: ¿Está publicado?
    final bool isPublished = eq.isPublishedForRent;
    String priceText;

    // Texto del precio
    if (isPublished) {
      if (eq.rentalInfo != null) {
        priceText = "Alquiler: \$ ${eq.rentalInfo!.monthlyFee.toStringAsFixed(0)} / mes";
      } else {
        priceText = "Publicado (Ver detalle)";
      }
    } else {
      priceText = "No publicado";
    }

    // Usamos Container + Material + InkWell para dar efecto de clic sin perder el estilo
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            // --- NAVEGACIÓN AL DETALLE ---
            // Pasamos el ID del equipo como argumento
            Navigator.pushNamed(
                context,
                '/provider_equipment_detail',
                arguments: eq.id
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 1. ICONO AZUL (Izquierda)
                Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF82C2F8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.kitchen, color: Colors.white, size: 36),
                ),

                const SizedBox(width: 16),

                // 2. DATOS (Centro)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eq.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      Text(
                        priceText,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),

                      // CHIP "DISPONIBLE"
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPublished ? const Color(0xFFE0F2F1) : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isPublished ? "Disponible" : "No Listado",
                          style: TextStyle(
                            color: isPublished ? const Color(0xFF2E7D32) : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. SWITCH (Derecha)
                Transform.scale(
                  scale: 0.9,
                  child: Switch(
                    value: isPublished,
                    activeColor: AppColors.primaryButton,
                    onChanged: _isProcessing
                        ? null
                        : (bool newValue) {
                      if (newValue) {
                        _showPublishDialog(context, provider, eq);
                      } else {
                        _showUnpublishDialog(context, provider, eq);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- DIÁLOGOS ---

  void _showPublishDialog(BuildContext context, EquipmentProvider provider, EquipmentEntity eq) {
    final priceController = TextEditingController(text: '100.00');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Publicar Equipo', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Ingresa el precio de alquiler mensual para activar este equipo en el mercado."),
            const SizedBox(height: 20),
            TextField(
              controller: priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                  labelText: 'Precio (USD)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.attach_money),
                  filled: true,
                  fillColor: Colors.grey.shade50
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButton,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
            ),
            onPressed: () async {
              final price = double.tryParse(priceController.text);
              if (price == null) return;
              Navigator.pop(ctx);

              setState(() => _isProcessing = true);
              try {
                final success = await provider.publishEquipment(eq.id, price);

                if (success) {
                  Fluttertoast.showToast(msg: "¡Equipo publicado!", backgroundColor: Colors.green);
                } else {
                  if (provider.errorMessage.contains("already rented") ||
                      provider.errorMessage.contains("cannot be published")) {
                    Fluttertoast.showToast(msg: "Actualizando estado...", backgroundColor: Colors.orange);
                  } else {
                    Fluttertoast.showToast(msg: "Error: ${provider.errorMessage}", backgroundColor: Colors.red);
                  }
                }
              } finally {
                if (mounted) await provider.loadEquipments();
                if (mounted) setState(() => _isProcessing = false);
              }
            },
            child: const Text('Activar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showUnpublishDialog(BuildContext context, EquipmentProvider provider, EquipmentEntity eq) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocultar Equipo', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('¿Deseas desactivar este equipo? Dejará de aparecer en el marketplace.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() => _isProcessing = true);

              final success = await provider.unpublishEquipment(eq.id);
              final isSuccess = success || provider.errorMessage.contains('not published');

              if (isSuccess) {
                Fluttertoast.showToast(msg: "Equipo ocultado", backgroundColor: Colors.grey);
                if (mounted) await provider.loadEquipments();
              } else {
                Fluttertoast.showToast(msg: "Error: ${provider.errorMessage}", backgroundColor: Colors.red);
              }

              if (mounted) setState(() => _isProcessing = false);
            },
            child: const Text('Desactivar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}