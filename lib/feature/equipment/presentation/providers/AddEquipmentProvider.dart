import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
// (Usando tus nombres de archivo 'PascalCase.dart')
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/CreateEquipmentUseCase.dart';

/// Define los posibles estados de la UI para la pantalla de "Añadir Equipo".
enum AddEquipmentState {
  initial,
  loading,
  success,
  error
}

/// El "ViewModel" para la pantalla de "Añadir Equipo".
class AddEquipmentProvider extends ChangeNotifier {
  final CreateEquipmentUseCase createEquipmentUseCase;

  AddEquipmentProvider({required this.createEquipmentUseCase});

  // --- Estados de la UI ---
  AddEquipmentState _state = AddEquipmentState.initial;
  AddEquipmentState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  EquipmentEntity? _createdEquipment;
  EquipmentEntity? get createdEquipment => _createdEquipment;

  /// Método que la UI llamará al presionar "Guardar Equipo".
  Future<void> createEquipment({
    required String name,
    required String type,
    required String model,
    required String serialNumber,
    required int ownerId,
    required String code,
    required String notes,
    required String ownerType,
    required String locationName,
    required String manufacturer,
    required String ownershipType,
    required String locationAddress,
    required String technicalDetails,
    required String energyConsumptionUnit,
    required double cost,
    required double currentTemperature,
    required double setTemperature,
    required double optimalTemperatureMin,
    required double optimalTemperatureMax,
    required double locationLatitude,
    required double locationLongitude,
    required double energyConsumptionCurrent,
    required double energyConsumptionAverage,
  }) async {
    _state = AddEquipmentState.loading;
    notifyListeners();

    final failureOrSuccess = await createEquipmentUseCase(
      name: name,
      type: type,
      model: model,
      serialNumber: serialNumber,
      ownerId: ownerId,
      code: code,
      notes: notes,
      ownerType: ownerType,
      locationName: locationName,
      manufacturer: manufacturer,
      ownershipType: ownershipType,
      locationAddress: locationAddress,
      technicalDetails: technicalDetails,
      energyConsumptionUnit: energyConsumptionUnit,
      cost: cost,
      currentTemperature: currentTemperature,
      setTemperature: setTemperature,
      optimalTemperatureMin: optimalTemperatureMin,
      optimalTemperatureMax: optimalTemperatureMax,
      locationLatitude: locationLatitude,
      locationLongitude: locationLongitude,
      energyConsumptionCurrent: energyConsumptionCurrent,
      energyConsumptionAverage: energyConsumptionAverage,
    );

    // Maneja la respuesta (Either<Failure, EquipmentEntity>)
    failureOrSuccess.fold(
          (failure) {
        // --- Caso de Error ---
        _errorMessage = _mapFailureToMessage(failure);
        _state = AddEquipmentState.error;
      },
          (newEquipment) {
        // --- Caso de Éxito ---
        _createdEquipment = newEquipment;
        _state = AddEquipmentState.success;
      },
    );

    notifyListeners();
  }

  /// Resetea el estado para un nuevo formulario
  void resetState() {
    _state = AddEquipmentState.initial;
    _errorMessage = '';
    _createdEquipment = null;
    // No notificamos a los listeners para evitar reconstrucciones
    // innecesarias si la UI ya ha navegado.
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