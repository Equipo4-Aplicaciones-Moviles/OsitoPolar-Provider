import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/CreateEquipmentUseCase.dart';
// --- ¡AÑADIDO! ---
import 'package:osito_polar_app/feature/equipment/domain/usecases/UpdateEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/GetEquipmentByIdUseCase.dart';


/// Define los posibles estados de la UI para la pantalla de "Añadir/Editar Equipo".
enum AddEquipmentState {
  initial, // Formulario vacío
  loading, // Cargando datos (para editar) o Guardando
  success, // Guardado exitoso
  error,   // Error al guardar o cargar
  dataLoaded, // Datos cargados en el formulario (Modo Edición)
}

/// El "ViewModel" para la pantalla de "Añadir/Editar Equipo".
class AddEquipmentProvider extends ChangeNotifier {
  // --- ¡MODIFICADO! Inyectamos los 3 UseCases ---
  final CreateEquipmentUseCase createEquipmentUseCase;
  final UpdateEquipmentUseCase updateEquipmentUseCase;
  final GetEquipmentByIdUseCase getEquipmentByIdUseCase;

  AddEquipmentProvider({
    required this.createEquipmentUseCase,
    required this.updateEquipmentUseCase,
    required this.getEquipmentByIdUseCase,
  });

  // --- Estados de la UI ---
  AddEquipmentState _state = AddEquipmentState.initial;
  AddEquipmentState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  EquipmentEntity? _editingEquipment; // Guarda el equipo que estamos editando
  EquipmentEntity? get editingEquipment => _editingEquipment;

  bool get isEditMode => _editingEquipment != null;

  // --- LÓGICA DE CARGA (Para Modo Edición) ---

  /// Carga los datos de un equipo existente en el formulario.
  Future<void> loadEquipmentForEdit(int equipmentId) async {
    _state = AddEquipmentState.loading;
    notifyListeners();

    final failureOrEquipment = await getEquipmentByIdUseCase(equipmentId);

    failureOrEquipment.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = AddEquipmentState.error;
      },
          (equipment) {
        _editingEquipment = equipment;
        _state = AddEquipmentState.dataLoaded; // ¡Listo para editar!
      },
    );
    notifyListeners();
  }

  // --- LÓGICA DE GUARDADO (Crear o Actualizar) ---

  /// Método genérico que la UI llamará al presionar "Guardar".
  /// Decide si debe 'crear' o 'actualizar'.
  Future<void> saveEquipment(Map<String, dynamic> equipmentData) async {
    _state = AddEquipmentState.loading;
    notifyListeners();

    // Decide qué UseCase llamar
    if (isEditMode) {
      // --- Modo UPDATE ---
      await _updateEquipment(equipmentData);
    } else {
      // --- Modo CREATE ---
      await _createEquipment(equipmentData);
    }
  }

  /// Lógica de CREAR (Privada)
  Future<void> _createEquipment(Map<String, dynamic> equipmentData) async {
    final failureOrSuccess = await createEquipmentUseCase(equipmentData);

    failureOrSuccess.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = AddEquipmentState.error;
      },
          (newEquipment) {
        _editingEquipment = newEquipment; // Guardamos el equipo creado
        _state = AddEquipmentState.success;
      },
    );
    notifyListeners();
  }

  /// Lógica de ACTUALIZAR (Privada)
  Future<void> _updateEquipment(Map<String, dynamic> equipmentData) async {
    if (_editingEquipment == null) {
      _errorMessage = "Error: No se está editando ningún equipo.";
      _state = AddEquipmentState.error;
      notifyListeners();
      return;
    }

    final failureOrSuccess = await updateEquipmentUseCase(
      _editingEquipment!.id, // Pasa el ID del equipo que estamos editando
      equipmentData,
    );

    failureOrSuccess.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = AddEquipmentState.error;
      },
          (updatedEquipment) {
        _editingEquipment = updatedEquipment; // Guarda el equipo actualizado
        _state = AddEquipmentState.success;
      },
    );
    notifyListeners();
  }

  /// Resetea el estado
  void resetState() {
    _state = AddEquipmentState.initial;
    _errorMessage = '';
    _editingEquipment = null; // ¡Importante! Limpia el modo edición
    notifyListeners();
  }

  /// Solo limpia el estado (sin notificar), usado al salir de la página
  void clear() {
    _state = AddEquipmentState.initial;
    _errorMessage = '';
    _editingEquipment = null;
  }
  void acknowledgeStateHandled() {
    _state = AddEquipmentState.initial;
    // ¡No notifica!
    // ¡No borra _editingEquipment!
  }
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Error del servidor. Revisa los campos e inténtalo más tarde.';
      default:
        return 'Un error inesperado ocurrió.';
    }
  }
}