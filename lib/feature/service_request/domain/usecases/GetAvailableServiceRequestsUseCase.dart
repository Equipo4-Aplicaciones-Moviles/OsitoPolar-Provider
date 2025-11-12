import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
// --- ¡AQUÍ LO IMPORTAMOS! ---
import 'package:osito_polar_app/core/usecases/UseCase.dart';
// ------------------------------
import 'package:osito_polar_app/feature/service_request/domain/entities/ServiceRequestEntity.dart';
import 'package:osito_polar_app/feature/service_request/domain/repositories/ServiceRequestRepository.dart';

/// Este es el UseCase que tu 'ProviderHomeProvider' usará.
///
/// Implementa nuestro "molde" UseCase y le dice:
/// 1. El tipo de Éxito es: List<ServiceRequestEntity>
/// 2. El tipo de Parámetro es: NoParams (porque no necesita un ID)
class GetAvailableServiceRequestsUseCase implements UseCase<List<ServiceRequestEntity>, NoParams> {

  // Depende del "contrato" (Repository)
  final ServiceRequestRepository repository;

  GetAvailableServiceRequestsUseCase(this.repository);

  /// Llama al método del repositorio que obtiene los trabajos del marketplace.
  ///
  /// El 'call' aquí simplemente reenvía la llamada al repositorio.
  @override
  Future<Either<Failure, List<ServiceRequestEntity>>> call(NoParams params) async {
    return await repository.getAvailableServiceRequests();
  }
}