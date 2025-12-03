import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/AddEquipmentProvider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';

class AddEquipmentPage extends StatefulWidget {
  final int? equipmentId;

  const AddEquipmentPage({
    super.key,
    this.equipmentId,
  });

  @override
  State<AddEquipmentPage> createState() => _AddEquipmentPageState();
}

class _AddEquipmentPageState extends State<AddEquipmentPage> {
  // --- Controladores ---
  final _nameController = TextEditingController();
  final _modelController = TextEditingController();
  final _serialNumberController = TextEditingController();
  final _codeController = TextEditingController();
  final _notesController = TextEditingController();
  final _locationNameController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _locationAddressController = TextEditingController();
  final _technicalDetailsController = TextEditingController();
  final _costController = TextEditingController(text: '0.0');

  final _optimalTemperatureMinController = TextEditingController(text: '-18.0');
  final _optimalTemperatureMaxController = TextEditingController(text: '-15.0');

  final _currentTemperatureController = TextEditingController(text: '0.0');
  final _setTemperatureController = TextEditingController(text: '0.0');
  final _energyConsumptionCurrentController = TextEditingController(text: '0.0');
  final _energyConsumptionAverageController = TextEditingController(text: '0.0');
  final _energyConsumptionUnitController = TextEditingController(text: 'kWh');

  // --- Estado para los Dropdowns ---
  String? _selectedType;
  final List<String> _equipmentTypes = ['Freezer', 'ColdRoom', 'Refrigerator'];

  bool get _isEditMode => widget.equipmentId != null;

  // --- Estado para la navegación por pasos simulada ---
  int _currentStep = 1;
  final int _totalSteps = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddEquipmentProvider>().clear();
      if (_isEditMode) {
        context.read<AddEquipmentProvider>().loadEquipmentForEdit(widget.equipmentId!);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _modelController.dispose();
    _serialNumberController.dispose();
    _codeController.dispose();
    _notesController.dispose();
    _locationNameController.dispose();
    _manufacturerController.dispose();
    _locationAddressController.dispose();
    _technicalDetailsController.dispose();
    _costController.dispose();
    _optimalTemperatureMinController.dispose();
    _optimalTemperatureMaxController.dispose();
    _currentTemperatureController.dispose();
    _setTemperatureController.dispose();
    _energyConsumptionCurrentController.dispose();
    _energyConsumptionAverageController.dispose();
    _energyConsumptionUnitController.dispose();
    super.dispose();
  }

  /// Método que se llama al presionar "Guardar"
  void _onSavePressed() {
    // --- VALIDACIÓN SIMPLIFICADA ---
    if (_nameController.text.isEmpty ||
        _serialNumberController.text.isEmpty ||
        _codeController.text.isEmpty ||
        _locationNameController.text.isEmpty ||
        _manufacturerController.text.isEmpty ||
        _selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error: Por favor completa la información principal.'),
        backgroundColor: Colors.orange,
      ));
      return;
    }

    // --- ¡LLAMADA AL PROVIDER CON HARDCODES! ---
    final Map<String, dynamic> equipmentData = {
      // Información Básica y de Perfil
      'name': _nameController.text,
      'type': _selectedType!,
      'model': _modelController.text,
      'serialNumber': _serialNumberController.text,
      'code': _codeController.text,
      'manufacturer': _manufacturerController.text,
      'notes': _notesController.text,
      'cost': double.tryParse(_costController.text) ?? 0.0,

      // Ubicación
      'locationName': _locationNameController.text,
      'locationAddress': _locationAddressController.text, // <-- Aún enviamos el controller
      'technicalDetails': _technicalDetailsController.text,

      // --- HARDCODEADOS (Valores Internos) ---
      'ownerId': 0, 'ownerType': 'Provider', 'ownershipType': 'Owned',
      'currentTemperature': double.tryParse(_currentTemperatureController.text) ?? 0.0,
      'setTemperature': double.tryParse(_setTemperatureController.text) ?? 0.0,
      'optimalTemperatureMin': double.tryParse(_optimalTemperatureMinController.text) ?? -18.0,
      'optimalTemperatureMax': double.tryParse(_optimalTemperatureMaxController.text) ?? -15.0,
      'energyConsumptionUnit': _energyConsumptionUnitController.text,
      'energyConsumptionCurrent': double.tryParse(_energyConsumptionCurrentController.text) ?? 0.0,
      'energyConsumptionAverage': double.tryParse(_energyConsumptionAverageController.text) ?? 0.0,
      'locationLatitude': 0.0,
      'locationLongitude': 0.0,
    };

    context.read<AddEquipmentProvider>().saveEquipment(equipmentData);
  }

  /// Helper para rellenar los campos en modo edición
  void _populateFormFields(EquipmentEntity equipment) {
    _nameController.text = equipment.name;
    _modelController.text = equipment.model;
    _serialNumberController.text = equipment.serialNumber;
    _codeController.text = equipment.code;
    _manufacturerController.text = equipment.manufacturer;
    // Asumimos que el costo está en la entidad
    // _costController.text = equipment.cost.toString(); // Esto falla si cost no está en la Entity
    _notesController.text = equipment.notes;
    _locationNameController.text = equipment.locationName;

    // --- ¡CORRECCIÓN HACK! COMENTAR LAS LÍNEAS QUE ROMPEN ---
    // El campo 'locationAddress' no existe en la Entity, ¡así que lo saltamos!
    // _locationAddressController.text = equipment.locationAddress;

    _technicalDetailsController.text = equipment.technicalDetails;

    // Asumimos que los óptimos sí existen para rellenarlos
    // _optimalTemperatureMinController.text = equipment.optimalTemperatureMin.toString();
    // _optimalTemperatureMaxController.text = equipment.optimalTemperatureMax.toString();

    if (_equipmentTypes.contains(equipment.type)) {
      _selectedType = equipment.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddEquipmentProvider>();
    final state = provider.state;
    final bool isLoading = (state == AddEquipmentState.loading);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final providerRead = context.read<AddEquipmentProvider>();
      if (state == AddEquipmentState.dataLoaded && providerRead.editingEquipment != null) {
        _populateFormFields(providerRead.editingEquipment!);
        providerRead.acknowledgeStateHandled();
      }
      if (state == AddEquipmentState.success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_isEditMode ? '¡Equipo actualizado!' : '¡Equipo creado!'),
            backgroundColor: Colors.green));
        providerRead.clear();
        Navigator.pop(context);
      }
      if (state == AddEquipmentState.error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: ${provider.errorMessage}'),
            backgroundColor: Colors.red));
        providerRead.resetState();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      // AppBar más minimalista y con el título de la página/sección en grande
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Fondo transparente
        elevation: 0, // Sin sombra
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.iconColor),
          onPressed: () {
            context.read<AddEquipmentProvider>().clear();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Registro', // Usamos un nombre más genérico para la estética
          style: const TextStyle(color: AppColors.logoColor, fontWeight: FontWeight.normal, fontFamily: 'Inter', fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()))
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container( // Reemplazamos Card por Container para el Box Decoration
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.0), // Borde más redondeado
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              // Simulamos el fondo degradado blanco/azul
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.95),
                  AppColors.cardBackground.withOpacity(0.8),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // Título principal como en la imagen
                  Text(
                    _isEditMode ? 'Editar Equipo' : 'Añadir Nuevo Equipo',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: AppColors.title),
                  ),
                  const SizedBox(height: 8),

                  // Texto secundario y link a Login/Volver
                  Row(
                    children: [
                      Text(
                        _isEditMode ? 'Revisa la información' : 'Completa la información',
                        style: TextStyle(fontSize: 14, color: AppColors.textColor.withOpacity(0.7)),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Volver',
                          style: TextStyle(
                            color: AppColors.primaryButton,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- NAVEGACIÓN POR PASOS (Step Indicator) ---
                  _buildStepIndicator(),
                  const SizedBox(height: 24),

                  // --- SECCIONES DE FORMULARIO CON PASOS ---
                  _currentStep == 1
                      ? _buildStepOneFields() // Información Básica y Ubicación
                      : _buildStepTwoFields(), // Configuración

                  const SizedBox(height: 32),

                  // --- Botones de Navegación/Guardar ---
                  _buildNavigationButtons(isLoading),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- BUILDERS DE SECCIONES (Nuevos) ---

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Paso 1
        _buildStepItem(1, 'Información Principal', _currentStep == 1),
        Expanded(
          child: Container(
            height: 1,
            color: _currentStep > 1 ? AppColors.primaryButton : AppColors.cardBorder,
          ),
        ),
        // Paso 2
        _buildStepItem(2, 'Configuración', _currentStep == 2),
      ],
    );
  }

  Widget _buildStepItem(int step, String title, bool isActive) {
    Color circleColor = isActive ? AppColors.primaryButton : AppColors.cardBorder;
    Color numberColor = isActive ? AppColors.buttonLabel : AppColors.textColor;
    Color titleColor = isActive ? AppColors.primaryButton : AppColors.textColor.withOpacity(0.7);

    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryButton, width: isActive ? 0 : 1),
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                color: numberColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: titleColor,
          ),
        )
      ],
    );
  }

  Widget _buildStepOneFields() {
    final bool isLoading = context.watch<AddEquipmentProvider>().state == AddEquipmentState.loading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Datos Esenciales'),
        _buildTextField(controller: _nameController, labelText: 'Nombre del Equipo (*)', isEnabled: !isLoading),
        const SizedBox(height: 16),
        _buildDropdownField(
          value: _selectedType,
          labelText: 'Tipo *',
          items: _equipmentTypes,
          onChanged: (val) => setState(() => _selectedType = val),
          isEnabled: !isLoading,
        ),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _buildTextField(controller: _manufacturerController, labelText: 'Fabricante (*)', isEnabled: !isLoading)),
          const SizedBox(width: 16),
          Expanded(child: _buildTextField(controller: _modelController, labelText: 'Modelo', isEnabled: !isLoading)),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _buildTextField(controller: _serialNumberController, labelText: 'N° Serie (*)', isEnabled: !isLoading)),
          const SizedBox(width: 16),
          Expanded(child: _buildTextField(controller: _codeController, labelText: 'Código (*)', isEnabled: !isLoading)),
        ]),

        // --- UBICACIÓN ---
        _buildSectionTitle('Ubicación y Costo'),
        _buildTextField(controller: _locationNameController, labelText: 'Nombre de Ubicación (*)', isEnabled: !isLoading),
        const SizedBox(height: 16),
        _buildTextField(controller: _locationAddressController, labelText: 'Dirección', isEnabled: !isLoading),
        const SizedBox(height: 16),
        _buildTextField(controller: _costController, labelText: 'Costo de Adquisición', keyboardType: TextInputType.number, isEnabled: !isLoading),
      ],
    );
  }

  Widget _buildStepTwoFields() {
    final bool isLoading = context.watch<AddEquipmentProvider>().state == AddEquipmentState.loading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // --- CONFIGURACIÓN ---
        _buildSectionTitle('Temperaturas y Notas'),
        _buildTextField(controller: _technicalDetailsController, labelText: 'Especificaciones Técnicas', isEnabled: !isLoading),
        const SizedBox(height: 16.0),

        Row(children: [
          Expanded(child: _buildTextField(
              controller: _optimalTemperatureMinController,
              labelText: 'Temp. Óptima Mín (°C)',
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              isEnabled: !isLoading)),
          const SizedBox(width: 16),
          Expanded(child: _buildTextField(
              controller: _optimalTemperatureMaxController,
              labelText: 'Temp. Óptima Máx (°C)',
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              isEnabled: !isLoading)),
        ]),

        const SizedBox(height: 16.0),
        _buildTextField(controller: _notesController, labelText: 'Notas Adicionales'),
      ],
    );
  }

  Widget _buildNavigationButtons(bool isLoading) {
    if (_currentStep == 1) {
      return ElevatedButton(
        onPressed: isLoading ? null : () => setState(() => _currentStep = 2),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryButton,
          foregroundColor: AppColors.buttonLabel,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: const Text(
          'Siguiente',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      );
    } else {
      // Step 2: Botón de Guardar / Actualizar
      return Column(
        children: [
          // Botón Anterior
          TextButton(
            onPressed: isLoading ? null : () => setState(() => _currentStep = 1),
            child: Text(
              'Volver a Información Principal',
              style: TextStyle(color: AppColors.textColor.withOpacity(0.7)),
            ),
          ),
          const SizedBox(height: 8),

          // Botón Principal de Guardar
          ElevatedButton(
            onPressed: isLoading ? null : _onSavePressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryButton,
              foregroundColor: AppColors.buttonLabel,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
                : Text(
              _isEditMode ? 'Actualizar Equipo' : 'Guardar Equipo',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ],
      );
    }
  }

  // Helper para títulos de sección (sin cambios en la función, pero con nuevo uso)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
            fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.title),
      ),
    );
  }

  /// Helper para campos de texto (se añade un pequeño padding a la etiqueta para que se vea más flotante)
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
        floatingLabelBehavior: FloatingLabelBehavior.always, // Para que la etiqueta esté siempre arriba
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18), // Más padding
        filled: true,
        fillColor: AppColors.textFieldBackground,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), // Sin borde visible
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryButton, width: 2)),
        labelStyle: const TextStyle(color: AppColors.textColor, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  /// Helper para Dropdowns (similar al cambio de TextField)
  Widget _buildDropdownField({
    required String? value,
    required String labelText,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    bool isEnabled = true,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: isEnabled ? onChanged : null,
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always, // Para que la etiqueta esté siempre arriba
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18), // Más padding
        filled: true,
        fillColor: AppColors.textFieldBackground,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryButton, width: 2)),
        labelStyle: const TextStyle(color: AppColors.textColor, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}