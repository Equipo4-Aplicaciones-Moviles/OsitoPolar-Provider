import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/GetEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/DeleteEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/service_request/domain/entities/ServiceRequestEntity.dart';
import 'package:osito_polar_app/feature/service_request/domain/usecases/GetAvailableServiceRequestsUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/PublishEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/UnpublishEquipmentUseCase.dart';
// (Importa NoParams)
import 'package:osito_polar_app/core/usecases/UseCase.dart';

/// Define los posibles estados de la UI para el Dashboard (Provider Home).
enum ProviderHomeState { initial, loading, success, error }

/// El "ViewModel" para la pantalla de ProviderHomePage.
class ProviderHomeProvider extends ChangeNotifier {
  final GetEquipmentsUseCase getEquipmentsUseCase;
  final DeleteEquipmentUseCase deleteEquipmentUseCase;
  final GetAvailableServiceRequestsUseCase getAvailableServiceRequestsUseCase;
  final PublishEquipmentUseCase publishEquipmentUseCase;
  final UnpublishEquipmentUseCase unpublishEquipmentUseCase;

  ProviderHomeProvider({
    required this.getEquipmentsUseCase,
    required this.deleteEquipmentUseCase,
    required this.getAvailableServiceRequestsUseCase,
    required this.publishEquipmentUseCase,
    required this.unpublishEquipmentUseCase,
  });

  // --- Estados de la UI ---
  ProviderHomeState _state = ProviderHomeState.initial;
  ProviderHomeState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // --- Datos ---
  List<EquipmentEntity> _equipments = [];
  List<EquipmentEntity> get equipments => _equipments;
  List<ServiceRequestEntity> _serviceRequests = [];
  List<ServiceRequestEntity> get serviceRequests => _serviceRequests;

  /// Método que la UI llamará en `initState()` para cargar todos los datos.
  Future<void> loadDashboardData() async {
    _state = ProviderHomeState.loading;
    notifyListeners();

    // 1. Llama al UseCase de Equipos
    // --- ¡AJUSTE AQUÍ! ---
    final failureOrEquipments = await getEquipmentsUseCase();

    // 2. Maneja la respuesta
    failureOrEquipments.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = ProviderHomeState.error;
      },
          (equipmentList) {
        _equipments = equipmentList;
        _state = ProviderHomeState.success;
      },
    );

    // Si la carga de equipos falla, salimos
    if (_state == ProviderHomeState.error) {
      notifyListeners();
      return;
    }

    // 3. Llama al UseCase de Service Requests
    final failureOrServiceRequests =
    await getAvailableServiceRequestsUseCase(NoParams());

    // 4. Maneja la respuesta
    failureOrServiceRequests.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = ProviderHomeState.error;
      },
          (requestList) {
        _serviceRequests = requestList;
        _state = ProviderHomeState.success; // ¡Éxito total!
      },
    );
    notifyListeners();
  }

  /// --- ¡MÉTODO DELETE CORREGIDO! ---
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

    // ¡Ya no llamamos a loadDashboardData() aquí!
    notifyListeners(); // Solo notifica (en caso de error)
    return success; // Devolvemos el resultado a la UI
  }

  /// --- ¡MÉTODO PUBLISH CORREGIDO! ---
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


  /// --- ¡MÉTODO UNPUBLISH CORREGIDO! ---
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


  /// Convierte un objeto Failure en un mensaje legible para el usuario.
  String _mapFailureToMessage(Failure failure) {
    // 1. Comprueba si es un ServerFailure Y si tiene un mensaje.
    if (failure is ServerFailure && failure.message != null) {
      // ¡Si tiene mensaje, úsalo! (Ej. "403 Forbidden")
      return failure.message!;
    }

    // 2. Si no, usa un mensaje genérico.
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Error del servidor. Inténtalo más tarde.';
      default:
        return 'Un error inesperado ocurrió.';
    }
  }
}