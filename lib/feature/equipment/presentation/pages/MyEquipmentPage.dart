import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/feature/provider-dashboard/presentation/widgets/ProviderDrawer.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.title),
        title: const Text(
          'Inventario',
          style: TextStyle(
            color: AppColors.logoColor,
            fontWeight: FontWeight.w900,
            fontSize: 20,
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
      return Center(child: Text('Error: ${provider.errorMessage}', style: const TextStyle(color: Colors.red)));
    }
    return _buildDashboardContent(context, provider);
  }

  Widget _buildDashboardContent(BuildContext context, EquipmentProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text(
            "Mis equipos",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black87, fontFamily: 'Inter'),
          ),
        ),
        Expanded(
          child: provider.equipments.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
            padding: const EdgeInsets.all(16),
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
      child: Text("No tienes equipos registrados.", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
    );
  }

  // --- TARJETA IDÉNTICA A LA IMAGEN ---
  Widget _buildEquipmentCard(EquipmentEntity eq, EquipmentProvider provider) {

    // Estado: ¿Está publicado?
    final bool isPublished = eq.isPublishedForRent;
    String priceText;

    // Texto del precio (si no está publicado, mostramos 0 o guiones)
    if (isPublished) {
      if (eq.rentalInfo != null) {
        // Si tenemos el objeto (ej. acabamos de publicar)
        priceText = "Alquiler: \$ ${eq.rentalInfo!.monthlyFee.toStringAsFixed(0)} / mes";
      } else {
        // Si sabemos que está alquilado por el 'ownershipType', pero no tenemos el precio
        priceText = "Publicado (Ver detalle para precio)";
      }
    } else {
      priceText = "No publicado";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // Bordes muy redondos
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // 1. ICONO AZUL (Izquierda)
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF82C2F8), // Azul claro como la imagen
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.kitchen, color: Colors.white, size: 36), // Icono blanco sobre azul
          ),

          const SizedBox(width: 16),

          // 2. DATOS (Centro)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del Equipo
                Text(
                  eq.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Precio
                Text(
                  priceText,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 8),

                // CHIP "DISPONIBLE" (Verde)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPublished ? const Color(0xFFE0F2F1) : const Color(0xFFF5F5F5), // Verde claro o Gris
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isPublished ? "Disponible" : "No Listado",
                    style: TextStyle(
                      color: isPublished ? const Color(0xFF2E7D32) : Colors.grey, // Texto Verde o Gris
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
            scale: 0.9, // Un poco más pequeño para que se vea elegante
            child: Switch(
              value: isPublished,
              activeColor: AppColors.primaryButton, // Azul cuando está ON
              onChanged: _isProcessing
                  ? null
                  : (bool newValue) {
                if (newValue) {
                  // Si lo prende -> Publicar
                  _showPublishDialog(context, provider, eq);
                } else {
                  // Si lo apaga -> Ocultar
                  _showUnpublishDialog(context, provider, eq);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- DIÁLOGOS ---

  void _showPublishDialog(BuildContext context, EquipmentProvider provider, EquipmentEntity eq) {
    final priceController = TextEditingController(text: '100.00');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Publicar Equipo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Ingresa el precio de alquiler mensual para activar este equipo en el mercado."),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Precio (USD)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryButton),
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
                  // SI FALLA, MIRAMOS EL ERROR
                  if (provider.errorMessage.contains("already rented") ||
                      provider.errorMessage.contains("cannot be published")) {

                    Fluttertoast.showToast(msg: "Actualizando estado...", backgroundColor: Colors.orange);
                    // El equipo ya estaba publicado, pero la UI no lo sabía.
                    // Al recargar, deberíamos intentar forzar la actualización.
                  } else {
                    Fluttertoast.showToast(msg: "Error: ${provider.errorMessage}", backgroundColor: Colors.red);
                  }
                }
              } finally {
                // SIEMPRE recargamos para sincronizar con la verdad del backend
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
        title: const Text('Ocultar Equipo'),
        content: const Text('¿Deseas desactivar este equipo? Dejará de aparecer en el marketplace.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
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