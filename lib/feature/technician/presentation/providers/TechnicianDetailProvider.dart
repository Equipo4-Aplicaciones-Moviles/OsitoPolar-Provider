// --- ¡ARCHIVO NUEVO! ---

import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/technician/domain/entities/TechnicianEntity.dart';
import 'package:osito_polar_app/feature/technician/domain/usecases/GetTechnicianByIdUseCase.dart';

// Estados para la página de detalle
enum TechnicianDetailState {
  initial,
  loading,
  success,
  error
}

class TechnicianDetailProvider extends ChangeNotifier {
  final GetTechnicianByIdUseCase getTechnicianByIdUseCase;

  TechnicianDetailProvider({
    required this.getTechnicianByIdUseCase,
  });

  TechnicianDetailState _state = TechnicianDetailState.initial;
  TechnicianDetailState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  TechnicianEntity? _technician; // Aquí guardamos el técnico cargado
  TechnicianEntity? get technician => _technician;

  /// Carga los detalles de un técnico específico por su ID
  Future<void> loadTechnician(int technicianId) async {
    _state = TechnicianDetailState.loading;
    notifyListeners();

    final failureOrTechnician = await getTechnicianByIdUseCase(technicianId);

    failureOrTechnician.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = TechnicianDetailState.error;
      },
          (technicianData) {
        _technician = technicianData;
        _state = TechnicianDetailState.success;
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