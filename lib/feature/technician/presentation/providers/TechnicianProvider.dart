import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import 'package:osito_polar_app/feature/technician/domain/entities/TechnicianEntity.dart';
import 'package:osito_polar_app/feature/technician/domain/usecases/GetTechnicianUseCase.dart';
import 'package:osito_polar_app/feature/technician/domain/usecases/CreateTechnicianUseCase.dart';

enum TechnicianState {
  initial,
  loading,
  success,
  error
}

class TechnicianProvider extends ChangeNotifier {
  final GetTechniciansUseCase getTechniciansUseCase;
  final CreateTechnicianUseCase createTechnicianUseCase;

  TechnicianProvider({
    required this.getTechniciansUseCase,
    required this.createTechnicianUseCase,
  });

  TechnicianState _state = TechnicianState.initial;
  TechnicianState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<TechnicianEntity> _technicians = [];
  List<TechnicianEntity> get technicians => _technicians;

  /// Carga la lista de técnicos
  Future<void> loadTechnicians() async {
    _state = TechnicianState.loading;
    notifyListeners();

    final failureOrTechnicians = await getTechniciansUseCase(NoParams());

    failureOrTechnicians.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = TechnicianState.error;
      },
          (technicianList) {
        _technicians = technicianList;
        _state = TechnicianState.success;
      },
    );
    notifyListeners();
  }

  /// Crea un nuevo técnico
  Future<bool> createTechnician({
    required String name,
    required String specialization,
    required String phone,
    required String email,
    required String availability,
    required int companyId, // (Deberíamos obtener esto del provider de login)
  }) async {
    _state = TechnicianState.loading;
    notifyListeners();

    final technicianData = {
      "name": name,
      "specialization": specialization,
      "phone": phone,
      "email": email,
      "availability": availability,
      "companyId": companyId,
    };

    final failureOrTechnician = await createTechnicianUseCase(technicianData);

    bool success = false;
    failureOrTechnician.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = TechnicianState.error;
        success = false;
      },
          (newTechnician) {
        _errorMessage = '';
        _state = TechnicianState.success;
        success = true;
        // (Opcional: recargar la lista)
        // loadTechnicians();
      },
    );

    // Si fue exitoso, recarga la lista para que se vea el nuevo
    if (success) {
      await loadTechnicians();
    }

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