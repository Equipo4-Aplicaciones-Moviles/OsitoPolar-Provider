import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/GetEquipmentByIdUseCase.dart';

/// Define los posibles estados de la UI para la pantalla de "Detalle de Equipo".
enum EquipmentDetailState {
  initial,
  loading,
  success,
  error
}

/// El "ViewModel" para la pantalla de ProviderEquipmentDetailPage.
class EquipmentDetailProvider extends ChangeNotifier {
  final GetEquipmentByIdUseCase getEquipmentByIdUseCase;

  EquipmentDetailProvider({required this.getEquipmentByIdUseCase});

  // --- Estados de la UI ---
  EquipmentDetailState _state = EquipmentDetailState.initial;
  EquipmentDetailState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  EquipmentEntity? _equipment;
  EquipmentEntity? get equipment => _equipment;

  /// Método que la UI llamará en `initState()` para cargar los datos del equipo.
  Future<void> fetchEquipmentDetails(int equipmentId) async {
    _state = EquipmentDetailState.loading;
    notifyListeners();

    final failureOrEquipment = await getEquipmentByIdUseCase(equipmentId);

    failureOrEquipment.fold(
          (failure) {
        // --- Caso de Error ---
        _errorMessage = _mapFailureToMessage(failure);
        _state = EquipmentDetailState.error;
      },
          (equipmentData) {
        // --- Caso de Éxito ---
        _equipment = equipmentData;
        _state = EquipmentDetailState.success;
      },
    );

    notifyListeners();
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Error del servidor. No se pudo cargar el equipo.';
      default:
        return 'Un error inesperado ocurrió.';
    }
  }
}