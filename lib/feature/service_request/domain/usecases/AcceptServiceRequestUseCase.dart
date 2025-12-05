import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import 'package:osito_polar_app/feature/service_request/domain/repositories/ServiceRequestRepository.dart';

/// Este es el UseCase que tu 'ProviderHomeProvider' llamará.
///
/// Implementa nuestro "molde" UseCase y le dice:
/// 1. El tipo de Éxito es: void (no devuelve nada)
/// 2. El tipo de Parámetro es: int (el ID de la solicitud a aceptar)
class AcceptServiceRequestUseCase implements UseCase<void, int> {

  // Depende del "contrato" (Repository)
  final ServiceRequestRepository repository;

  AcceptServiceRequestUseCase(this.repository);

  /// Llama al método del repositorio que acepta el trabajo.
  @override
  Future<Either<Failure, void>> call(int serviceRequestId) async {
    return await repository.acceptServiceRequest(
      serviceRequestId: serviceRequestId,
    );
  }
}