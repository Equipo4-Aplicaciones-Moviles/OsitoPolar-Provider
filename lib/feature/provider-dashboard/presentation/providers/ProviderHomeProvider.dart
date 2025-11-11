import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/GetEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/DeleteEquipmentUseCase.dart';

import 'package:osito_polar_app/feature/service_request/domain/entities/ServiceRequestEntity.dart';
import 'package:osito_polar_app/feature/service_request/domain/usecases/GetServiceRequestsUseCase.dart';
/// Define los posibles estados de la UI para el Dashboard (Provider Home).
enum ProviderHomeState {
  initial,
  loading,
  success,
  error
}

/// El "ViewModel" para la pantalla de ProviderHomePage.
class ProviderHomeProvider extends ChangeNotifier {
  final GetEquipmentsUseCase getEquipmentsUseCase;
  // TODO: Añadir aquí los UseCases para Clientes, Técnicos, etc.
  final DeleteEquipmentUseCase deleteEquipmentUseCase;
  final GetServiceRequestsUseCase getServiceRequestsUseCase;
  ProviderHomeProvider({
    required this.getEquipmentsUseCase,
    required this.deleteEquipmentUseCase,
    required this.getServiceRequestsUseCase,
    // ...
  });

  // --- Estados de la UI ---
  ProviderHomeState _state = ProviderHomeState.initial;
  ProviderHomeState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // --- Datos ---
  List<EquipmentEntity> _equipments = [];
  List<EquipmentEntity> get equipments => _equipments;
  // TODO: Añadir listas para Clientes, Técnicos, etc.
  List<ServiceRequestEntity> _serviceRequests = [];
  List<ServiceRequestEntity> get serviceRequests => _serviceRequests;
  // --- Lógica de Negocio ---

  /// Método que la UI llamará en `initState()` para cargar todos los datos.
  Future<void> loadDashboardData() async {
    _state = ProviderHomeState.loading;
    notifyListeners();

    // 1. Llama al UseCase de Equipos
    final failureOrEquipments = await getEquipmentsUseCase();

    // 2. Maneja la respuesta (Either<Failure, List<EquipmentEntity>>)
    failureOrEquipments.fold(
          (failure) {
        // --- Caso de Error ---
        _errorMessage = _mapFailureToMessage(failure);
        _state = ProviderHomeState.error;
      },
          (equipmentList) {
        // --- Caso de Éxito ---
        _equipments = equipmentList;
        _state = ProviderHomeState.success;
      },
    );

    // TODO: Llamar a los UseCases de Clientes, Técnicos, etc. aquí.
    final failureOrServiceRequests = await getServiceRequestsUseCase();

    // 4. Manejamos la respuesta de Mantenimientos
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
    // Notifica a la UI sobre el nuevo estado (éxito o error)
    notifyListeners();
  }

  Future<bool> deleteEquipment(int equipmentId) async {
    // No ponemos el estado en 'loading' para no ocultar la lista,
    // la UI mostrará su propio feedback (ej. un SnackBar)

    final failureOrSuccess = await deleteEquipmentUseCase(equipmentId);

    bool success = false; // Variable para rastrear el resultado

    failureOrSuccess.fold(
          (failure) {
        // --- Caso de Error ---
        _errorMessage = _mapFailureToMessage(failure);
        // No cambiamos el estado principal, solo devolvemos el error
        success = false;
      },
          (_) {
        // --- Caso de Éxito ---
        _errorMessage = ''; // Limpiamos errores anteriores
        success = true;
        // ¡No notificamos todavía!
      },
    );

    if (success) {
      // Si el 'delete' fue exitoso, VOLVEMOS a cargar la lista
      // para que el equipo borrado desaparezca de la UI.
      // 'loadDashboardData' se encargará de llamar a 'notifyListeners()'.
      await loadDashboardData();
    } else {
      // Si falló, notificamos para que la UI muestre el error (si es necesario)
      notifyListeners();
    }

    return success; // Devolvemos el resultado a la UI
  }


  /// Convierte un objeto Failure en un mensaje legible para el usuario.
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
      // TODO: Mejorar mensajes (ej. "Token expirado, vuelve a iniciar sesión")
        return 'Error del servidor. Inténtalo más tarde.';
      default:
        return 'Un error inesperado ocurrió.';
    }
  }
}