import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/feature/technician/presentation/providers/TechnicianDetailProvider.dart';
import 'package:osito_polar_app/feature/technician/domain/entities/TechnicianEntity.dart';

class TechnicianDetailPage extends StatefulWidget {
  final int technicianId;

  const TechnicianDetailPage({super.key, required this.technicianId});

  @override
  State<TechnicianDetailPage> createState() => _TechnicianDetailPageState();
}

class _TechnicianDetailPageState extends State<TechnicianDetailPage> {

  @override
  void initState() {
    super.initState();
    // Le decimos al provider que cargue los datos de este técnico
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TechnicianDetailProvider>().loadTechnician(widget.technicianId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TechnicianDetailProvider>();
    final state = provider.state;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Ficha Técnica', style: TextStyle(color: AppColors.logoColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: AppColors.cardBorder,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.iconColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(context, provider, state),
    );
  }

  Widget _buildBody(BuildContext context, TechnicianDetailProvider provider, TechnicianDetailState state) {
    switch (state) {
      case TechnicianDetailState.loading:
      case TechnicianDetailState.initial:
        return const Center(child: CircularProgressIndicator(color: AppColors.primaryButton));
      case TechnicianDetailState.error:
        return Center(child: Text('Error: ${provider.errorMessage}', style: const TextStyle(color: Colors.red)));
      case TechnicianDetailState.success:
        if (provider.technician == null) {
          return const Center(child: Text('No se encontraron datos del técnico.'));
        }
        // ¡Mostramos la ficha!
        return _buildTechnicianDetails(provider.technician!);
    }
  }

  /// Construye la UI de la Ficha Técnica (basado en tu UI de Vue)
  Widget _buildTechnicianDetails(TechnicianEntity technician) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Cabecera con Avatar y Nombre ---
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryButton,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  technician.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  technician.specialization ?? 'Sin especialización',
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.title,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 48, thickness: 1, color: AppColors.cardBorder),

          // --- Fila de Detalles (imitando tu CSS 'status-available') ---
          _buildDetailRow(
            Icons.access_time_filled,
            'Disponibilidad',
            technician.availability ?? 'Desconocida',
            // Damos color al estado
            valueColor: _getAvailabilityColor(technician.availability),
          ),
          _buildDetailRow(
            Icons.star,
            'Rating Promedio',
            technician.averageRating > 0
                ? '${technician.averageRating.toStringAsFixed(1)} / 5'
                : 'N/A',
            valueColor: technician.averageRating > 0 ? Colors.orange[700] : AppColors.textColor,
          ),

          const SizedBox(height: 24),

          // --- Fila de Contacto ---
          _buildDetailRow(Icons.phone, 'Teléfono', technician.phone ?? 'No registrado'),
          _buildDetailRow(Icons.email, 'Email', technician.email ?? 'No registrado'),
          _buildDetailRow(Icons.business, 'ID de Compañía', technician.companyId.toString()),
        ],
      ),
    );
  }

  /// Helper para mostrar una fila de detalle (Icono, Label, Valor)
  Widget _buildDetailRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryButton, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? AppColors.textColor, // Usa color especial o el normal
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper para dar color al estado (como en tu CSS)
  Color _getAvailabilityColor(String? availability) {
    switch (availability?.toLowerCase()) {
      case 'available':
        return Colors.green[700]!;
      case 'occupied':
        return Colors.orange[700]!;
      case 'onleave': // (Asumiendo 'OnLeave' de tu Vue)
        return Colors.red[700]!;
      default:
        return AppColors.textColor;
    }
  }
}