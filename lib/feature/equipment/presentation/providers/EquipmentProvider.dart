// --- ¡ARCHIVO RENOMBRADO Y LIMPIO! ---
// Ruta: feature/equipment/presentation/providers/EquipmentProvider.dart

import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/GetEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/DeleteEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/PublishEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/UnpublishEquipmentUseCase.dart';

// (Cambiamos el nombre del enum)
enum EquipmentState {
  initial,
  loading,
  success,
  error
}

// --- ¡CLASE RENOMBRADA! ---
// (Ya no se llama ProviderHomeProvider)
class EquipmentProvider extends ChangeNotifier {

  // --- Dependencias (Solo de Equipment) ---
  final GetEquipmentsUseCase getEquipmentsUseCase;
  final DeleteEquipmentUseCase deleteEquipmentUseCase;
  final PublishEquipmentUseCase publishEquipmentUseCase;
  final UnpublishEquipmentUseCase unpublishEquipmentUseCase;

  EquipmentProvider({
    required this.getEquipmentsUseCase,
    required this.deleteEquipmentUseCase,
    required this.publishEquipmentUseCase,
    required this.unpublishEquipmentUseCase,
  });

  // --- Estados y Datos (Solo de Equipment) ---
  EquipmentState _state = EquipmentState.initial;
  EquipmentState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<EquipmentEntity> _equipments = [];
  List<EquipmentEntity> get equipments => _equipments;

  // --- Lógica de Negocio (Solo de Equipment) ---

  Future<void> loadEquipments() async {
    _state = EquipmentState.loading;
    notifyListeners();

    final failureOrEquipments = await getEquipmentsUseCase(NoParams());

    failureOrEquipments.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = EquipmentState.error;
      },
          (equipmentList) {
        _equipments = equipmentList;
        _state = EquipmentState.success;
      },
    );
    notifyListeners();
  }

  Future<bool> deleteEquipment(int equipmentId) async {
    final failureOrSuccess = await deleteEquipmentUseCase(equipmentId);
    bool success = false;
    failureOrSuccess.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        success = false;
      },
          (_) {
        _errorMessage = '';
        success = true;
      },
    );

    notifyListeners();
    return success;
  }

  Future<bool> publishEquipment(int equipmentId, double monthlyFee) async {
    final params = PublishEquipmentParams(
      equipmentId: equipmentId,
      monthlyFee: monthlyFee,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 365)),
    );
    final failureOrSuccess = await publishEquipmentUseCase(params);
    bool success = false;
    failureOrSuccess.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        success = false;
      },
          (updatedEquipment) {
        _errorMessage = '';
        success = true;
      },
    );
    notifyListeners();
    return success;
  }

  Future<bool> unpublishEquipment(int equipmentId) async {
    final failureOrSuccess = await unpublishEquipmentUseCase(equipmentId);
    bool success = false;
    failureOrSuccess.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        success = false;
      },
          (updatedEquipment) {
        _errorMessage = '';
        success = true;
      },
    );
    notifyListeners();
    return success;
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure && failure.message != null) {
      return failure.message!;
    }
    return 'Un error inesperado ocurrió.';
  }
}