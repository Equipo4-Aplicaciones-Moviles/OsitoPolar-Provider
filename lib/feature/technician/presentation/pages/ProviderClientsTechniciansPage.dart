import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:osito_polar_app/core/theme/app_colors.dart';
// Providers y Entidades
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';
import 'package:osito_polar_app/feature/technician/presentation/providers/TechnicianProvider.dart';
import 'package:osito_polar_app/feature/technician/domain/entities/TechnicianEntity.dart';

class ProviderClientsTechniciansPage extends StatefulWidget {
  const ProviderClientsTechniciansPage({super.key});

  @override
  State<ProviderClientsTechniciansPage> createState() =>
      _ProviderClientsTechniciansPageState();
}

class _ProviderClientsTechniciansPageState extends State<ProviderClientsTechniciansPage> {
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TechnicianProvider>().loadTechnicians();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TechnicianProvider>();
    final state = provider.state;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Fondo gris claro
      // Usamos SafeArea y quitamos AppBar para el diseño limpio
      body: SafeArea(
        child: _buildBody(context, provider, state),
      ),

      // Botón flotante cuadrado (como en tu diseño)
      floatingActionButton: SizedBox(
        height: 60,
        width: 60,
        child: FloatingActionButton(
          onPressed: _isProcessing
              ? null
              : () => _showAddTechnicianDialog(context),
          backgroundColor: const Color(0xFF0277BD), // Azul fuerte
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Cuadrado redondeado
          child: const Icon(Icons.add, size: 36),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, TechnicianProvider provider, TechnicianState state) {
    if (state == TechnicianState.loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryButton));
    }
    if (state == TechnicianState.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Error: ${provider.errorMessage}', style: const TextStyle(color: Colors.red)),
        ),
      );
    }
    return _buildContent(context, provider);
  }

  Widget _buildContent(BuildContext context, TechnicianProvider provider) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // --- TÍTULOS CENTRADOS ---
        const Text(
          "Mis técnicos",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.black87,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Gestión de personal y calificaciones",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 24),

        // --- LISTA DE TÉCNICOS ---
        Expanded(
          child: provider.technicians.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: provider.technicians.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 16),
            itemBuilder: (ctx, i) => _buildTechnicianCard(context, provider.technicians[i]),
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
          Icon(Icons.people_outline, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "No tienes técnicos registrados.",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  // --- TARJETA ESTILO DISEÑO ---
  Widget _buildTechnicianCard(BuildContext context, TechnicianEntity tech) {
    // Determinamos color y texto del estado
    Color chipColor;
    Color chipTextColor;
    String statusText;

    // Lógica simple de estado (puedes ajustarla según lo que devuelva tu API)
    // Asumimos que availability viene como "Available", "Busy", "Off" o similar.
    final availability = tech.availability?.toLowerCase() ?? 'available';

    if (availability.contains('bus') || availability.contains('ocupado')) {
      statusText = "Ocupado";
      chipColor = const Color(0xFFEF9A9A); // Rojo claro
      chipTextColor = const Color(0xFFC62828); // Rojo oscuro
    } else if (availability.contains('off') || availability.contains('descanso')) {
      statusText = "Descanso";
      chipColor = const Color(0xFFE0E0E0); // Gris claro
      chipTextColor = const Color(0xFF616161); // Gris oscuro
    } else {
      statusText = "Disponible";
      chipColor = const Color(0xFFC8E6C9); // Verde claro
      chipTextColor = const Color(0xFF2E7D32); // Verde oscuro
    }

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: InkWell(
        onTap: () {
          // Navegar a detalle
          Navigator.pushNamed(context, '/provider_technician_detail', arguments: tech.id);
        },
        child: Row(
          children: [
            // 1. AVATAR (Cuadrado Azul)
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF64B5F6), // Azul cielo
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 32),
            ),

            const SizedBox(width: 16),

            // 2. INFO CENTRAL
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tech.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tech.specialization ?? "Técnico General",
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 6),

                  // Rating (Estrella)
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        // Si rating es 0, mostramos "Nuevo" o "0.0"
                        tech.averageRating > 0 ? tech.averageRating.toStringAsFixed(1) : "Nuevo",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // 3. ESTADO (Chip a la derecha)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: chipColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusText,
                style: TextStyle(color: chipTextColor, fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- DIÁLOGO DE AGREGAR ---
  void _showAddTechnicianDialog(BuildContext context) {
    final nameController = TextEditingController();
    final specController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    // No pedimos Rating ni Estado, se crean por defecto.

    final technicianProvider = context.read<TechnicianProvider>();
    final loginProvider = context.read<ProviderLoginProvider>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Nuevo Técnico', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogTextField(controller: nameController, labelText: 'Nombre Completo', icon: Icons.person_outline),
                const SizedBox(height: 12),
                _buildDialogTextField(controller: specController, labelText: 'Especialización', icon: Icons.work_outline),
                const SizedBox(height: 12),
                _buildDialogTextField(controller: phoneController, labelText: 'Teléfono', keyboardType: TextInputType.phone, icon: Icons.phone_outlined),
                const SizedBox(height: 12),
                _buildDialogTextField(controller: emailController, labelText: 'Email', keyboardType: TextInputType.emailAddress, icon: Icons.email_outlined),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButton,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                final int? companyId = loginProvider.user?.profileId; // O loginProvider.user.id dependiendo de tu lógica

                // Validación rápida
                if (companyId == null || nameController.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Faltan datos requeridos");
                  return;
                }

                Navigator.pop(ctx);
                setState(() => _isProcessing = true);

                final success = await technicianProvider.createTechnician(
                  name: nameController.text,
                  specialization: specController.text,
                  phone: phoneController.text,
                  email: emailController.text,
                  availability: "Available", // Por defecto al crear
                  companyId: companyId,
                );

                if (success) {
                  Fluttertoast.showToast(msg: "Técnico creado con éxito", backgroundColor: Colors.green);
                } else {
                  Fluttertoast.showToast(msg: "Error: ${technicianProvider.errorMessage}", backgroundColor: Colors.red);
                }

                if (mounted) setState(() => _isProcessing = false);
              },
              child: const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey, size: 20) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }
}