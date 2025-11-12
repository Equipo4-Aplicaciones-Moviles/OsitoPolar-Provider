import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/service_request/domain/entities/ServiceRequestEntity.dart';

/// El "CONTRATO" (Interfaz) para el Repositorio de Solicitudes de Servicio.
abstract class ServiceRequestRepository {
  /// Obtiene la lista de todas las solicitudes de servicio (mantenimientos)
  Future<Either<Failure, List<ServiceRequestEntity>>> getServiceRequests();
  Future<Either<Failure, List<ServiceRequestEntity>>> getAvailableServiceRequests();
// TODO: Añadir getServiceRequestById, createServiceRequest, etc.
}