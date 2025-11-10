import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/AddEquipmentProvider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';

/// Pantalla de Formulario para "Añadir un Nuevo Equipo".
class AddEquipmentPage extends StatefulWidget {
  const AddEquipmentPage({super.key});

  @override
  State<AddEquipmentPage> createState() => _AddEquipmentPageState();
}

class _AddEquipmentPageState extends State<AddEquipmentPage> {
  // --- Controladores ---
  // Campos Principales
  final _nameController = TextEditingController();
  final _modelController = TextEditingController();
  final _serialNumberController = TextEditingController();
  final _ownerIdController = TextEditingController();

  // Campos Requeridos por el Error 400
  final _codeController = TextEditingController();
  final _notesController = TextEditingController();
  final _ownerTypeController = TextEditingController();
  final _locationNameController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _locationAddressController = TextEditingController();
  final _technicalDetailsController = TextEditingController();
  final _energyConsumptionUnitController = TextEditingController();

  // Campos Numéricos (los inicializamos con '0' para evitar errores de parseo)
  final _costController = TextEditingController(text: '0.0');
  final _currentTemperatureController = TextEditingController(text: '0.0');
  final _setTemperatureController = TextEditingController(text: '0.0');
  final _optimalTemperatureMinController = TextEditingController(text: '-18.0');
  final _optimalTemperatureMaxController = TextEditingController(text: '-15.0');
  // (Lat/Lng se envían como 0.0, no necesitamos controllers)
  final _energyConsumptionCurrentController = TextEditingController(text: '0.0');
  final _energyConsumptionAverageController = TextEditingController(text: '0.0');

  // --- Estado para los Dropdowns ---
  // (Basado en tus Enums de C#: EEquipmentType y EOwnershipType)
  String? _selectedType;
  final List<String> _equipmentTypes = ['Freezer', 'ColdRoom', 'Refrigerator'];

  String? _selectedOwnership;
  final List<String> _ownershipTypes = ['Owned', 'Rented', 'Leased'];


  @override
  void dispose() {
    // Damos dispose a TODOS los controllers
    _nameController.dispose();
    _modelController.dispose();
    _serialNumberController.dispose();
    _ownerIdController.dispose();
    _codeController.dispose();
    _notesController.dispose();
    _ownerTypeController.dispose();
    _locationNameController.dispose();
    _manufacturerController.dispose();
    _locationAddressController.dispose();
    _technicalDetailsController.dispose();
    _energyConsumptionUnitController.dispose();
    _costController.dispose();
    _currentTemperatureController.dispose();
    _setTemperatureController.dispose();
    _optimalTemperatureMinController.dispose();
    _optimalTemperatureMaxController.dispose();
    _energyConsumptionCurrentController.dispose();
    _energyConsumptionAverageController.dispose();
    super.dispose();
  }

  /// Método que se llama al presionar "Guardar"
  void _onSavePressed() {
    // --- ¡VALIDACIÓN ACTUALIZADA! ---
    if (_nameController.text.isEmpty ||
        _serialNumberController.text.isEmpty ||
        _ownerIdController.text.isEmpty ||
        _codeController.text.isEmpty ||
        _notesController.text.isEmpty ||
        _ownerTypeController.text.isEmpty ||
        _locationNameController.text.isEmpty ||
        _manufacturerController.text.isEmpty ||
        // (Validamos los nuevos dropdowns)
        _selectedOwnership == null ||
        _selectedType == null ||
        _locationAddressController.text.isEmpty ||
        _technicalDetailsController.text.isEmpty ||
        _energyConsumptionUnitController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          content: Text('Error: Todos los campos marcados con (*) son obligatorios.'),
          backgroundColor: Colors.orange,
        ));
      return;
    }

    // --- ¡LLAMADA AL PROVIDER ACTUALIZADA! ---
    context.read<AddEquipmentProvider>().createEquipment(
      // Campos Principales
      name: _nameController.text,
      type: _selectedType!, // <-- Usamos el valor del Dropdown
      model: _modelController.text,
      serialNumber: _serialNumberController.text,
      ownerId: int.tryParse(_ownerIdController.text) ?? 0,

      // Campos Requeridos (Strings)
      code: _codeController.text,
      notes: _notesController.text,
      ownerType: _ownerTypeController.text,
      locationName: _locationNameController.text,
      manufacturer: _manufacturerController.text,
      ownershipType: _selectedOwnership!, // <-- Usamos el valor del Dropdown
      locationAddress: _locationAddressController.text,
      technicalDetails: _technicalDetailsController.text,
      energyConsumptionUnit: _energyConsumptionUnitController.text,

      // Campos Requeridos (Numéricos)
      cost: double.tryParse(_costController.text) ?? 0.0,
      currentTemperature: double.tryParse(_currentTemperatureController.text) ?? 0.0,
      setTemperature: double.tryParse(_setTemperatureController.text) ?? 0.0,
      optimalTemperatureMin: double.tryParse(_optimalTemperatureMinController.text) ?? 0.0,
      optimalTemperatureMax: double.tryParse(_optimalTemperatureMaxController.text) ?? 0.0,

      // --- ¡SOLUCIÓN DE UX! ---
      // Enviamos 0.0 para Lat/Lng. No se lo pedimos al usuario.
      locationLatitude: 0.0,
      locationLongitude: 0.0,

      energyConsumptionCurrent: double.tryParse(_energyConsumptionCurrentController.text) ?? 0.0,
      energyConsumptionAverage: double.tryParse(_energyConsumptionAverageController.text) ?? 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos al provider para reaccionar a los cambios de estado (ej. spinner)
    final provider = context.watch<AddEquipmentProvider>();
    final state = provider.state;

    // --- Listener para Efectos Secundarios (Snackbars, Navegación) ---
    // Usamos addPostFrameCallback para manejar esto DESPUÉS del build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Usamos 'context.read' aquí para solo *actuar*
      final provider = context.read<AddEquipmentProvider>();

      if (provider.state == AddEquipmentState.success) {
        // ÉXITO: Mostrar SnackBar y volver al dashboard
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(
            content: Text('¡Equipo creado exitosamente!'),
            backgroundColor: Colors.green,
          ));
        provider.resetState(); // Limpia el provider
        Navigator.pop(context); // Vuelve a la pantalla anterior
      }
      if (provider.state == AddEquipmentState.error) {
        // ERROR: Mostrar SnackBar con el error
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('Error: ${provider.errorMessage}'),
            backgroundColor: Colors.red,
          ));
        provider.resetState(); // Limpia el provider para reintentar
      }
    });

    // Devolvemos el Scaffold
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: AppColors.cardBorder,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.iconColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Añadir Nuevo Equipo',
          style: TextStyle(
            color: AppColors.logoColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 0,
            color: AppColors.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: const BorderSide(color: AppColors.cardBorder, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- ¡FORMULARIO ACTUALIZADO CON DROPDOWNS! ---

                  // --- Sección Principal ---
                  _buildSectionTitle('Información Principal'),
                  _buildTextField(
                    controller: _nameController,
                    labelText: 'Nombre del Equipo (*)',
                    isEnabled: state != AddEquipmentState.loading,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _serialNumberController,
                    labelText: 'Número de Serie (*)',
                    isEnabled: state != AddEquipmentState.loading,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _codeController,
                    labelText: 'Código (*)',
                    isEnabled: state != AddEquipmentState.loading,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _manufacturerController,
                    labelText: 'Fabricante (*)',
                    isEnabled: state != AddEquipmentState.loading,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _modelController,
                    labelText: 'Modelo (ej. VF-200)',
                    isEnabled: state != AddEquipmentState.loading,
                  ),
                  const SizedBox(height: 16.0),

                  // --- ¡CAMPO "TIPO" MODIFICADO! ---
                  _buildDropdownField(
                    value: _selectedType,
                    labelText: 'Tipo (*)',
                    items: _equipmentTypes,
                    onChanged: (state == AddEquipmentState.loading)
                        ? null
                        : (newValue) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _technicalDetailsController,
                    labelText: 'Detalles Técnicos (*)',
                    isEnabled: state != AddEquipmentState.loading,
                  ),

                  // --- Sección de Propiedad ---
                  _buildSectionTitle('Propiedad'),
                  _buildTextField(
                    controller: _ownerIdController,
                    labelText: 'ID del Propietario (Cliente) (*)',
                    keyboardType: TextInputType.number,
                    isEnabled: state != AddEquipmentState.loading,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _ownerTypeController,
                    labelText: 'Tipo de Propietario (ej. Client) (*)',
                    isEnabled: state != AddEquipmentState.loading,
                  ),
                  const SizedBox(height: 16.0),

                  // --- ¡CAMPO "POSESIÓN" MODIFICADO! ---
                  _buildDropdownField(
                    value: _selectedOwnership,
                    labelText: 'Tipo de Posesión (*)',
                    items: _ownershipTypes,
                    onChanged: (state == AddEquipmentState.loading)
                        ? null
                        : (newValue) {
                      setState(() {
                        _selectedOwnership = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _costController,
                    labelText: 'Costo',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    isEnabled: state != AddEquipmentState.loading,
                  ),

                  // --- Sección de Localización ---
                  _buildSectionTitle('Localización'),
                  _buildTextField(
                    controller: _locationNameController,
                    labelText: 'Nombre de Localización (*)',
                    isEnabled: state != AddEquipmentState.loading,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _locationAddressController,
                    labelText: 'Dirección de Localización (*)',
                    isEnabled: state != AddEquipmentState.loading,
                  ),
                  // --- ¡CAMPOS LAT/LNG ELIMINADOS DE LA UI! ---

                  // --- Sección de Operación ---
                  _buildSectionTitle('Operación'),
                  Row(children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _currentTemperatureController,
                        labelText: 'Temp. Actual',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        isEnabled: state != AddEquipmentState.loading,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _setTemperatureController,
                        labelText: 'Temp. Deseada',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        isEnabled: state != AddEquipmentState.loading,
                      ),
                    ),
                  ],),
                  const SizedBox(height: 16.0),
                  Row(children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _optimalTemperatureMinController,
                        labelText: 'Temp. Óptima Mín',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        isEnabled: state != AddEquipmentState.loading,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _optimalTemperatureMaxController,
                        labelText: 'Temp. Óptima Máx',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        isEnabled: state != AddEquipmentState.loading,
                      ),
                    ),
                  ],),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _energyConsumptionUnitController,
                    labelText: 'Unidad de Energía (ej. kWh) (*)',
                    isEnabled: state != AddEquipmentState.loading,
                  ),
                  const SizedBox(height: 16.0),
                  Row(children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _energyConsumptionCurrentController,
                        labelText: 'Consumo Actual',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        isEnabled: state != AddEquipmentState.loading,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _energyConsumptionAverageController,
                        labelText: 'Consumo Promedio',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        isEnabled: state != AddEquipmentState.loading,
                      ),
                    ),
                  ],),

                  // --- Notas y Botón ---
                  _buildSectionTitle('Otros'),
                  _buildTextField(
                    controller: _notesController,
                    labelText: 'Notas (*)',
                    isEnabled: state != AddEquipmentState.loading,
                  ),
                  const SizedBox(height: 32.0),

                  // --- Botón de Guardar ---
                  ElevatedButton(
                    onPressed: (state == AddEquipmentState.loading)
                        ? null // Deshabilita el botón si está cargando
                        : _onSavePressed, // Llama a nuestro método
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryButton,
                      foregroundColor: AppColors.buttonLabel,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: (state == AddEquipmentState.loading)
                        ? const CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : const Text(
                      'Guardar Equipo',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper para títulos de sección
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: AppColors.title,
        ),
      ),
    );
  }

  /// Helper para campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    bool isEnabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: isEnabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: AppColors.textFieldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.textFieldBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.textFieldBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.primaryButton,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textColor,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  // --- ¡NUEVO HELPER PARA DROPDOWNS! ---
  Widget _buildDropdownField({
    required String? value,
    required String labelText,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: const TextStyle(fontFamily: 'Inter')),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: AppColors.textFieldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.textFieldBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.textFieldBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.primaryButton,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textColor,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}