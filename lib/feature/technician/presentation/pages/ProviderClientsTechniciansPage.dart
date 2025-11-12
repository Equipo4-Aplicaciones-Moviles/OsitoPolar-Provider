import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/feature/provider-dashboard/presentation/widgets/ProviderDrawer.dart';
// --- ¡Importamos el provider de Auth para obtener nuestro ID de Compañía! ---
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';
// --- ¡Importamos el nuevo provider y la entidad de Técnico! ---
import 'package:osito_polar_app/feature/technician/presentation/providers/TechnicianProvider.dart';
import 'package:osito_polar_app/feature/technician/domain/entities/TechnicianEntity.dart';

class ProviderClientsTechniciansPage extends StatefulWidget {
  const ProviderClientsTechniciansPage({super.key});

  @override
  State<ProviderClientsTechniciansPage> createState() =>
      _ProviderClientsTechniciansPageState();
}

class _ProviderClientsTechniciansPageState
    extends State<ProviderClientsTechniciansPage> {
  bool _isProcessing = false; // Bloquea botones durante API calls

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Carga la lista de técnicos al abrir la página
      context.read<TechnicianProvider>().loadTechnicians();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TechnicianProvider>();
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
          'Gestión',
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
            ? null // Deshabilita si está cargando
            : () => _showAddTechnicianDialog(context),
        backgroundColor: AppColors.primaryButton,
        foregroundColor: AppColors.buttonLabel,
        tooltip: 'Añadir Técnico',
        child: const Icon(Icons.person_add_alt_1),
      ),
    );
  }

  /// Construye el cuerpo de la página (loading/error/success)
  Widget _buildBody(
      BuildContext context, TechnicianProvider provider, TechnicianState state) {
    switch (state) {
      case TechnicianState.initial:
      case TechnicianState.loading:
        return const Center(child: CircularProgressIndicator(color: AppColors.primaryButton));
      case TechnicianState.error:
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
      case TechnicianState.success:
        return _buildContent(context, provider);
    }
  }

  /// Muestra el contenido principal (Lista de Técnicos y Clientes)
  Widget _buildContent(BuildContext context, TechnicianProvider provider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Mis Técnicos"),
            const SizedBox(height: 16),
            _buildTechnicianList(context, provider.technicians),
            const SizedBox(height: 32),
            _buildSectionTitle("Mis Clientes"),
            const SizedBox(height: 16),
            _buildClientList(context), // (Sección de placeholder)
            const SizedBox(height: 80), // Espacio para el FAB
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

  /// Construye la lista de técnicos
  Widget _buildTechnicianList(
      BuildContext context, List<TechnicianEntity> technicians) {
    if (technicians.isEmpty) {
      return Card(
        elevation: 0,
        color: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        child: const Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: Text(
              'No has añadido ningún técnico. ¡Usa el botón (+) para empezar!',
              style: TextStyle(fontFamily: 'Inter', color: AppColors.textColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: technicians.length,
      itemBuilder: (context, index) {
        final technician = technicians[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildTechnicianCard(context, technician),
        );
      },
    );
  }

  /// Tarjeta individual para cada técnico
  Widget _buildTechnicianCard(
      BuildContext context, TechnicianEntity technician) {
    return Card(
      elevation: 1,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.primaryButton,
          foregroundColor: AppColors.buttonLabel,
          child: Icon(Icons.person),
        ),
        title: Text(
          technician.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
            fontFamily: 'Inter',
          ),
        ),
        subtitle: Text(
          technician.specialization ?? 'Sin especialización',
          style: const TextStyle(
            color: AppColors.textColor,
            fontFamily: 'Inter',
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.iconColor, size: 16),
        onTap: () {
          // TODO: Navegar a la página de detalles del técnico
        },
      ),
    );
  }

  /// Placeholder para la lista de clientes
  Widget _buildClientList(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            'La gestión de clientes estará disponible pronto.',
            style: TextStyle(fontFamily: 'Inter', color: AppColors.textColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// Muestra el diálogo (pop-up) para añadir un nuevo técnico
  void _showAddTechnicianDialog(BuildContext context) {
    // Controladores para el formulario del diálogo
    final nameController = TextEditingController();
    final specController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final availabilityController = TextEditingController(text: 'Full-Time'); // Valor por defecto

    // Obtenemos los providers AHORA, antes de que el diálogo se construya
    final technicianProvider = context.read<TechnicianProvider>();
    final loginProvider = context.read<ProviderLoginProvider>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          // Aplicamos tu paleta de colores
          backgroundColor: AppColors.backgroundLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: const BorderSide(color: AppColors.cardBorder, width: 1),
          ),
          title: const Text(
            'Añadir Nuevo Técnico',
            style: TextStyle(color: AppColors.title, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogTextField(controller: nameController, labelText: 'Nombre Completo'),
                const SizedBox(height: 16),
                _buildDialogTextField(controller: specController, labelText: 'Especialización'),
                const SizedBox(height: 16),
                _buildDialogTextField(controller: phoneController, labelText: 'Teléfono', keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                _buildDialogTextField(controller: emailController, labelText: 'Email', keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildDialogTextField(controller: availabilityController, labelText: 'Disponibilidad'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar', style: TextStyle(color: AppColors.textColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButton,
                foregroundColor: AppColors.buttonLabel,
              ),
              onPressed: () async {
                // 1. Obtenemos el ID de nuestra compañía (Provider)
                final int? companyId = loginProvider.user?.profileId;
                if (companyId == null) {
                  // Error: no estamos logueados correctamente
                  Fluttertoast.showToast(
                    msg: "Error: No se encontró ID de compañía. Vuelve a iniciar sesión.",
                    backgroundColor: Colors.red,
                    webBgColor: "#F44336",
                  );
                  return;
                }

                // (Opcional: validación de campos vacíos)
                if (nameController.text.isEmpty) {
                  Fluttertoast.showToast(msg: "El nombre es obligatorio.", backgroundColor: Colors.orange, webBgColor: "#FF9800");
                  return;
                }

                Navigator.pop(ctx); // Cierra el diálogo
                setState(() => _isProcessing = true); // Bloquea botones

                // 2. Llama al provider para crear el técnico
                final success = await technicianProvider.createTechnician(
                  name: nameController.text,
                  specialization: specController.text,
                  phone: phoneController.text,
                  email: emailController.text,
                  availability: availabilityController.text,
                  companyId: companyId,
                );

                // 3. Muestra el "toast" flotante
                Fluttertoast.showToast(
                  msg: success
                      ? '¡Técnico "${nameController.text}" creado!'
                      : 'Error: ${technicianProvider.errorMessage}',
                  backgroundColor: success ? Colors.green : Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                  gravity: ToastGravity.BOTTOM,
                  webBgColor: success ? "#4CAF50" : "#F44336",
                  timeInSecForIosWeb: 3,
                );

                // 4. (No necesitamos refrescar la lista, el provider ya lo hace)
                if (mounted) {
                  setState(() => _isProcessing = false); // Desbloquea botones
                }
              },
              child: const Text('Guardar Técnico'),
            ),
          ],
        );
      },
    );
  }

  /// Helper para los campos de texto DENTRO del diálogo
  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    // Usamos el InputDecorationTheme que definimos en main.dart
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        // (Los colores ya vienen del Theme en main.dart)
      ),
    );
  }
}
