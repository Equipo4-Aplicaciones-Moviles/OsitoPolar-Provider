import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/error/Failures.dart';

// Entidades
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentHealthEntity.dart';

// Casos de Uso
import 'package:osito_polar_app/feature/equipment/domain/usecases/GetEquipmentByIdUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/GetEquipmentHealthUseCase.dart';
// 1. IMPORTAR EL NUEVO CASO DE USO
import 'package:osito_polar_app/feature/equipment/domain/usecases/UpdateEquipmentOperationUseCase.dart';

enum EquipmentDetailState { initial, loading, success, error }

class EquipmentDetailProvider extends ChangeNotifier {
  final GetEquipmentByIdUseCase getEquipmentByIdUseCase;
  final GetEquipmentHealthUseCase getEquipmentHealthUseCase;
  // 2. AGREGAR LA DEPENDENCIA
  final UpdateEquipmentOperationUseCase updateEquipmentOperationUseCase;

  EquipmentDetailProvider({
    required this.getEquipmentByIdUseCase,
    required this.getEquipmentHealthUseCase,
    required this.updateEquipmentOperationUseCase, // Inyección
  });

  EquipmentDetailState _state = EquipmentDetailState.initial;
  EquipmentDetailState get state => _state;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  EquipmentEntity? _equipment;
  EquipmentEntity? get equipment => _equipment;

  EquipmentHealthEntity? _healthMetrics;
  EquipmentHealthEntity? get healthMetrics => _healthMetrics;

  bool _isHealthLoading = false;
  bool get isHealthLoading => _isHealthLoading;

  Future<void> fetchEquipmentDetails(int equipmentId) async {
    _state = EquipmentDetailState.loading;
    _equipment = null;
    _healthMetrics = null;
    notifyListeners();

    final result = await getEquipmentByIdUseCase(equipmentId);

    result.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = EquipmentDetailState.error;
        notifyListeners();
      },
          (data) {
        _equipment = data;
        _state = EquipmentDetailState.success;
        notifyListeners();
        fetchHealthMetrics(equipmentId);
      },
    );
  }

  Future<void> fetchHealthMetrics(int equipmentId) async {
    _isHealthLoading = true;
    notifyListeners();
    final result = await getEquipmentHealthUseCase(GetHealthParams(equipmentId: equipmentId, days: 7));
    result.fold(
          (f) => _isHealthLoading = false,
          (data) {
        _healthMetrics = data;
        _isHealthLoading = false;
        notifyListeners();
      },
    );
    notifyListeners();
  }

  // --- 3. MÉTODO ACTUALIZADO: AHORA USA LA API REAL ---
  Future<void> updateSetTemperature(int equipmentId, double newTemp) async {
    if (_equipment == null) return;

    // A. Actualización Optimista (La UI cambia inmediatamente)
    final previousTemp = _equipment!.setTemperature;
    _equipment = _equipment!.copyWith(setTemperature: newTemp);
    notifyListeners();

    // B. Llamada a la API Real
    final params = UpdateOperationParams(equipmentId: equipmentId, temperature: newTemp);
    final result = await updateEquipmentOperationUseCase(params);

    result.fold(
          (failure) {
        // Si falla, revertimos el cambio visual y mostramos error
        _equipment = _equipment!.copyWith(setTemperature: previousTemp);
        notifyListeners();
        print("Error actualizando temperatura: ${_mapFailureToMessage(failure)}");
      },
          (updatedEquipment) {
        // Éxito: Confirmamos con los datos reales del servidor
        _equipment = updatedEquipment;
        notifyListeners();
        print("Temperatura actualizada correctamente en el backend.");
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) return failure.message ?? 'Error del servidor';
    return 'Error desconocido';
  }
}