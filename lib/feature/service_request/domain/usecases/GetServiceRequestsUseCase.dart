import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/service_request/domain/entities/ServiceRequestEntity.dart';
import 'package:osito_polar_app/feature/service_request/domain/repositories/ServiceRequestRepository.dart';

/// El Caso de Uso (UseCase) para "Obtener todas las Solicitudes de Servicio".
class GetServiceRequestsUseCase {
  final ServiceRequestRepository repository;

  GetServiceRequestsUseCase(this.repository);

  /// El método `call` permite que el UseCase sea llamado como una función.
  Future<Either<Failure, List<ServiceRequestEntity>>> call() async {
    return await repository.getServiceRequests();
  }
}