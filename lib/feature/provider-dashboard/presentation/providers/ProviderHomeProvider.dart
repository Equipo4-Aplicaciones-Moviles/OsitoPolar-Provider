import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/GetEquipmentUseCase.dart';

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

  ProviderHomeProvider({
    required this.getEquipmentsUseCase,
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

    // Notifica a la UI sobre el nuevo estado (éxito o error)
    notifyListeners();
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