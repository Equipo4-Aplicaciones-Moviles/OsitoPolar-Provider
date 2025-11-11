import 'package:flutter/material.dart';
// (Tus importaciones existentes)
import 'package:osito_polar_app/feature/provider-dashboard/presentation/providers/ProviderHomeProvider.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/feature/provider-dashboard/presentation/widgets/ProviderDrawer.dart'; // (Usando tu 'PascalCase')
import 'package:osito_polar_app/feature/service_request/domain/entities/ServiceRequestEntity.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/feature/provider-dashboard/presentation/widgets/ProviderDrawer.dart'; // (Usando tu 'PascalCase')
class MyEquipmentPage extends StatefulWidget {
  const MyEquipmentPage({super.key});

  @override
  State<MyEquipmentPage> createState() => _MyEquipmentPageState();
}

class _MyEquipmentPageState extends State<MyEquipmentPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // (Usando tu clase 'ProviderHomeProvider')
      context.read<ProviderHomeProvider>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // (Usando tu clase 'ProviderHomeProvider')
    final provider = context.watch<ProviderHomeProvider>();
    final state = provider.state;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        // ... (Tu AppBar existente) ...
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: AppColors.cardBorder,
        leading: Builder( // <-- ¡CORREGIDO!
            builder: (BuildContext builderContext) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: AppColors.iconColor,
                  size: 30,
                ),
                onPressed: () {
                  Scaffold.of(builderContext).openDrawer(); // <-- ¡CORREGIDO!
                },
              );
            }
        ),
        title: const Text(
          'OsitoPolar',
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
        onPressed: () async {
          // Navega a la pantalla de añadir Y ESPERA
          await Navigator.pushNamed(context, '/provider_add_equipment');

          // CUANDO VUELVE, refresca la lista
          if (mounted) {
            context.read<ProviderHomeProvider>().loadDashboardData();
          }
        },
        backgroundColor: AppColors.primaryButton,
        foregroundColor: AppColors.buttonLabel,
        tooltip: 'Añadir Equipo',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Helper para construir el cuerpo de la pantalla según el estado
  Widget _buildBody(BuildContext context, ProviderHomeProvider provider, ProviderHomeState state) {
    switch (state) {
      case ProviderHomeState.initial:
      case ProviderHomeState.loading:
      // Muestra un spinner mientras carga
        return const Center(child: CircularProgressIndicator());
      case ProviderHomeState.error:
      // Muestra un mensaje de error si la API falla
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error: ${provider.errorMessage}\n\n'
                  '(Revisa la consola para más detalles. '
                  'Asegúrate de que el back-end esté corriendo y que '
                  'el token se esté enviando correctamente.)',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontFamily: 'Inter'),
            ),
          ),
        );
      case ProviderHomeState.success:
      // Muestra el nuevo diseño del dashboard
        return _buildDashboardContent(context, provider);
    }
  }

  /// El contenido del dashboard (basado en 'image_50263b.png')
  Widget _buildDashboardContent(BuildContext context, ProviderHomeProvider provider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECCIÓN: MIS EQUIPOS ---
            _buildSectionTitle(context, 'Mis equipos'),
            const SizedBox(height: 8),
            // Pasamos el provider completo
            _buildEquipmentList(context, provider),
            const SizedBox(height: 24),

            // --- SECCIÓN: MANTENIMIENTOS ---
            _buildSectionTitle(context, 'Mantenimientos'),
            const SizedBox(height: 8),
            // --- ¡MODIFICADO! Pasamos la lista REAL ---
            _buildMaintenanceList(context, provider.serviceRequests),

            // (Añadimos espacio al final para que el FAB no tape contenido)
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  /// Helper para construir los títulos de sección (ej. "Mis equipos")
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,
          fontSize: 22, // Más grande
          color: AppColors.title,
        ),
      ),
    );
  }

  /// Helper para la lista de equipos (horizontal)
  /// Acepta el 'ProviderHomeProvider'
  Widget _buildEquipmentList(BuildContext context, ProviderHomeProvider provider) {
    // Obtenemos la lista DESDE el provider
    final equipments = provider.equipments;

    if (equipments.isEmpty) {
      // Muestra un mensaje si la API no devuelve nada
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

    // Lista horizontal con 'PageView' para el efecto de carrusel
    return SizedBox(
      height: 480, // Altura fija para la tarjeta (ajusta según sea necesario)
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9), // Muestra parte de la sig/ant
        itemCount: equipments.length,
        itemBuilder: (context, index) {
          final equipment = equipments[index];
          // Añadimos un padding horizontal para el efecto de carrusel
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            // ¡Esta llamada AHORA SÍ es válida!
            child: _buildEquipmentCard(context, provider, equipment),
          );
        },
      ),
    );
  }

  /// Tarjeta de Equipo (basada en 'image_50263b.png')
  /// ¡Acepta el 'ProviderHomeProvider' para el 'delete'!
  Widget _buildEquipmentCard(BuildContext context, ProviderHomeProvider provider, EquipmentEntity equipment) {

    final statusColor = (equipment.status.toLowerCase() == 'active' || equipment.status.toLowerCase() == 'normal')
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
            // --- 1. Fila de Título y Estado ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.power_settings_new, color: Colors.green, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        equipment.name, // "Industrial Freezer XK-400"
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        '${equipment.type} ${equipment.model}', // "Congelador XK-400"
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(radius: 8, backgroundColor: statusColor),
              ],
            ),
            const SizedBox(height: 24),

            // --- 2. Imagen (Placeholder) ---
            Container(
              width: 100,
              height: 130,
              decoration: BoxDecoration(
                color: AppColors.textFieldBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Icon(Icons.kitchen_outlined,
                  color: AppColors.textColor, size: 60),
            ),
            const SizedBox(height: 16),

            // --- 3. Temperatura ---
            Text(
              '${equipment.currentTemperature.toStringAsFixed(0)}°', // "25°"
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color: AppColors.textColor,
              ),
            ),
            Text(
              '(${equipment.status})', // "(normal)"
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 24),

            // --- 4. Localización ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.textFieldBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, color: AppColors.textColor, size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      equipment.locationName, // "San Isidro Main Warehouse"
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(), // <-- Ocupa el espacio restante

            // --- 5. Fila de Botones (¡Aquí están!) ---
            Row(
              children: [
                // Botón Control (¡Este navega al Detalle!)
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // ¡Acción 1! Navegamos al detalle completo
                      Navigator.pushNamed(
                        context,
                        '/provider_equipment_detail', // La pantalla que SÍ tiene el diseño de detalle
                        arguments: equipment.id,
                      );
                    },
                    icon: const Icon(Icons.settings, size: 16),
                    label: const Text('Control'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryButton,
                      foregroundColor: AppColors.buttonLabel,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Botones Editar y Borrar
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () async {
                            // 1. Navega a la pantalla de Añadir/Editar
                            // 2. ¡LE PASA EL ID DEL EQUIPO!
                            await Navigator.pushNamed(
                              context,
                              '/provider_add_equipment',
                              arguments: equipment.id, // <-- ¡LA CLAVE!
                            );

                            // 3. Cuando vuelve, refresca la lista
                            if (mounted) {
                              provider.loadDashboardData();
                            }
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primaryButton,
                            foregroundColor: AppColors.buttonLabel,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () {
                            // (¡Esta es la lógica que implementamos!)
                            _showDeleteConfirmationDialog(context, provider, equipment);
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primaryButton,
                            foregroundColor: AppColors.buttonLabel,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Muestra un diálogo de alerta antes de borrar un equipo.
  void _showDeleteConfirmationDialog(BuildContext context, ProviderHomeProvider provider, EquipmentEntity equipment) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Borrado'),
          content: Text('¿Estás seguro de que quieres borrar el equipo "${equipment.name}"? Esta acción no se puede deshacer.'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cierra el diálogo
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Borrar', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                // 1. Cierra el diálogo
                Navigator.of(dialogContext).pop();

                // 2. Llama al provider para borrar
                final bool success = await provider.deleteEquipment(equipment.id);

                // 3. Muestra un SnackBar con el resultado
                // (Usamos 'mounted' por si el widget se destruyó)
                if (!mounted) return;

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                          success
                              ? '¡Equipo "${equipment.name}" borrado!'
                              : 'Error: ${provider.errorMessage}'
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
              },
            ),
          ],
        );
      },
    );
  }

  /// Helper para la tarjeta "Mantenimientos" (Datos falsos)
  Widget _buildMaintenanceList(BuildContext context, List<ServiceRequestEntity> requests) {

    if (requests.isEmpty) {
      // Muestra un mensaje si la API no devuelve nada
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
              'No se encontraron mantenimientos.',
              style: TextStyle(fontFamily: 'Inter', color: AppColors.textColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 280, // Altura fija para la tarjeta
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9), // Efecto carrusel
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildMaintenanceCard(
              context,
              title: request.title, // <-- ¡DATO REAL!
              client: 'Cliente ID: ${request.clientId ?? 'N/A'}', // <-- ¡DATO REAL!
              isPending: request.status.toLowerCase() == 'pending', // <-- ¡LÓGICA REAL!
            ),
          );
        },
      ),
    );
  }

  /// Helper para la tarjeta "Mantenimientos"
  Widget _buildMaintenanceCard(BuildContext context, {required String title, required String client, required bool isPending}) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Imagen (Placeholder)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.textFieldBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Icon(Icons.event_note, // Icono de Mantenimiento
                  color: AppColors.textColor, size: 60),
            ),
            const SizedBox(height: 16),
            // Título
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 8),
            // Cliente
            Text(
              client,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.textColor,
              ),
            ),
            const Spacer(), // Ocupa el espacio
            // Botones
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Lógica de "Solicitar"
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Color del diseño
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Solicitar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Lógica de "Pendiente"
                    },
                    child: Text(
                      'Pendiente',
                      style: TextStyle(
                          color: isPending ? Colors.red : Colors.grey, // Color del diseño
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
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
}