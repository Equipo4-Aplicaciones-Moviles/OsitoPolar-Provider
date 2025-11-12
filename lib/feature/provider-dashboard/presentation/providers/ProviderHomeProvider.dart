// --- ARCHIVO MODIFICADO ---
// Ruta: feature/provider-dashboard/presentation/providers/ProviderHomeProvider.dart

import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';

import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/GetEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/service_request/domain/entities/ServiceRequestEntity.dart';
import 'package:osito_polar_app/feature/service_request/domain/usecases/GetAvailableServiceRequestsUseCase.dart';

// (Este provider solo LEE datos para el resumen. No necesita los UseCases de 'Delete' o 'Publish')

enum ProviderHomeState { initial, loading, success, error }

class ProviderHomeProvider extends ChangeNotifier {

  final GetEquipmentsUseCase getEquipmentsUseCase;
  final GetAvailableServiceRequestsUseCase getAvailableServiceRequestsUseCase;

  ProviderHomeProvider({
    required this.getEquipmentsUseCase,
    required this.getAvailableServiceRequestsUseCase,
  });

  ProviderHomeState _state = ProviderHomeState.initial;
  ProviderHomeState get state => _state;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // --- Datos para el Resumen ---
  int _equipmentCount = 0;
  int get equipmentCount => _equipmentCount;
  int _marketplaceRequestCount = 0;
  int get marketplaceRequestCount => _marketplaceRequestCount;

  List<ServiceRequestEntity> _recentRequests = [];
  List<ServiceRequestEntity> get recentRequests => _recentRequests; // (Para una lista pequeña)

  Future<void> loadDashboardSummary() async {
    _state = ProviderHomeState.loading;
    notifyListeners();

    bool hasError = false;

    // 1. Cargar conteo de equipos
    final failureOrEquipments = await getEquipmentsUseCase(NoParams());
    failureOrEquipments.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = ProviderHomeState.error;
        hasError = true;
      },
          (equipmentList) {
        _equipmentCount = equipmentList.length;
      },
    );

    if (hasError) {
      notifyListeners();
      return;
    }

    // 2. Cargar conteo de marketplace
    final failureOrServiceRequests = await getAvailableServiceRequestsUseCase(NoParams());
    failureOrServiceRequests.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = ProviderHomeState.error;
      },
          (requestList) {
        _marketplaceRequestCount = requestList.length;
        _recentRequests = requestList.take(3).toList(); // Toma solo los 3 primeros
        _state = ProviderHomeState.success;
      },
    );
    notifyListeners();
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure && failure.message != null) {
      return failure.message!;
    }
    return 'Un error inesperado ocurrió.';
  }
}