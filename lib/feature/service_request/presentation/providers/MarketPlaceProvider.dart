import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import 'package:osito_polar_app/feature/service_request/domain/entities/ServiceRequestEntity.dart';
import 'package:osito_polar_app/feature/service_request/domain/usecases/GetAvailableServiceRequestsUseCase.dart';
import 'package:osito_polar_app/feature/service_request/domain/usecases/AcceptServiceRequestUseCase.dart';

// Definimos estados solo para esta página
enum MarketplaceState {
  initial,
  loading,
  success,
  error
}

class MarketplaceProvider extends ChangeNotifier {
  // --- Definimos sus dependencias ---
  final GetAvailableServiceRequestsUseCase getAvailableServiceRequestsUseCase;
  final AcceptServiceRequestUseCase acceptServiceRequestUseCase;

  MarketplaceProvider({
    required this.getAvailableServiceRequestsUseCase,
    required this.acceptServiceRequestUseCase,
  });

  // --- Estados y Datos ---
  MarketplaceState _state = MarketplaceState.initial;
  MarketplaceState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<ServiceRequestEntity> _serviceRequests = [];
  List<ServiceRequestEntity> get serviceRequests => _serviceRequests;

  // --- Lógica de Negocio (Movida desde el ProviderHomeProvider) ---

  /// Carga la lista de trabajos del marketplace
  Future<void> loadMarketplaceData() async {
    _state = MarketplaceState.loading;
    notifyListeners();

    final failureOrServiceRequests =
    await getAvailableServiceRequestsUseCase(NoParams());

    failureOrServiceRequests.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = MarketplaceState.error;
      },
          (requestList) {
        _serviceRequests = requestList;
        _state = MarketplaceState.success;
      },
    );
    notifyListeners();
  }

  /// Acepta un trabajo del marketplace
  Future<bool> acceptServiceRequest(int serviceRequestId) async {
    final failureOrSuccess = await acceptServiceRequestUseCase(serviceRequestId);

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

  /// Helper para mapear errores
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure && failure.message != null) {
      return failure.message!;
    }
    return 'Un error inesperado ocurrió.';
  }
}