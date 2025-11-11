import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/service_request/data/datasource/ServiceRequestRemoteDataSource.dart';
import 'package:osito_polar_app/feature/service_request/domain/entities/ServiceRequestEntity.dart';
import 'package:osito_polar_app/feature/service_request/domain/repositories/ServiceRequestRepository.dart';
// (Necesitamos el modelo para el mapeo)
import 'package:osito_polar_app/feature/service_request/data/models/ServiceRequestModel.dart';

/// La "IMPLEMENTACIÓN" del contrato ServiceRequestRepository.
class ServiceRequestRepositoryImpl implements ServiceRequestRepository {
  final ServiceRequestRemoteDataSource remoteDataSource;

  ServiceRequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ServiceRequestEntity>>> getServiceRequests() async {
    try {
      // 1. Llama al "cartero" (DataSource) para obtener los Modelos
      final serviceRequestModels = await remoteDataSource.getServiceRequests();

      // 2. Mapea la lista de Modelos (Data) a Entidades (Domain)
      final serviceRequestEntities = serviceRequestModels
          .map((model) => _mapModelToEntity(model))
          .toList();

      // 3. Retorna el éxito (Right)
      return Right(serviceRequestEntities);

    } on Exception {
      // 4. Si el "cartero" falla, retorna un fracaso (Left)
      return Left(ServerFailure());
    }
  }

  /// Helper privado para mapear el Modelo a la Entidad
  ServiceRequestEntity _mapModelToEntity(ServiceRequestModel model) {
    return ServiceRequestEntity(
      id: model.id,
      orderNumber: model.orderNumber,
      title: model.title,
      status: model.status,
      priority: model.priority,
      serviceType: model.serviceType,
      equipmentId: model.equipmentId,
      clientId: model.clientId,
      companyId: model.companyId,
    );
  }
}