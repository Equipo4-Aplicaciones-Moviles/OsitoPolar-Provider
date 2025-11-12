import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/error/Exceptions.dart'; // ¡Asegúrate de importar ServerException!
import 'package:osito_polar_app/feature/service_request/data/datasource/ServiceRequestRemoteDataSource.dart';
import 'package:osito_polar_app/feature/service_request/domain/entities/ServiceRequestEntity.dart';
import 'package:osito_polar_app/feature/service_request/domain/repositories/ServiceRequestRepository.dart';
import 'package:osito_polar_app/feature/service_request/data/models/ServiceRequestModel.dart'; // (Importa el Modelo)

/// La "IMPLEMENTACIÓN" del contrato ServiceRequestRepository.
class ServiceRequestRepositoryImpl implements ServiceRequestRepository {
  final ServiceRequestRemoteDataSource remoteDataSource;

  ServiceRequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ServiceRequestEntity>>> getServiceRequests() async {
    try {
      // 1. Llama al DataSource
      final serviceRequestModels = await remoteDataSource.getServiceRequests();

      // 2. ¡SOLUCIÓN! Simplemente "castea" la lista.
      // Esto funciona porque ServiceRequestModel HEREDA de ServiceRequestEntity.
      return Right(serviceRequestModels.cast<ServiceRequestEntity>());

    } on ServerException catch (e) { // <-- ¡MEJORADO!
      // 3. Si falla, pasa el mensaje de error
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) { // <-- ¡MEJORADO!
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceRequestEntity>>> getAvailableServiceRequests() async {
    try {
      final remoteServiceRequests = await remoteDataSource.getAvailableServiceRequests();

      // ¡Esto ya estaba correcto!
      return Right(remoteServiceRequests.cast<ServiceRequestEntity>());

    } on ServerException catch (e) { // <-- ¡MEJORADO!
      // Pasamos el mensaje de error para mostrarlo en la UI
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) { // <-- ¡MEJORADO!
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> acceptServiceRequest({
    required int serviceRequestId,
  }) async {
    try {
      await remoteDataSource.acceptServiceRequest(
        serviceRequestId: serviceRequestId,
      );
      return const Right(null);

    } on ServerException catch (e) { // <-- ¡MEJORADO!
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) { // <-- ¡MEJORADO!
      return Left(ServerFailure(message: e.toString()));
    }
  }

// --- ¡HELPER BORRADO! ---
// El método '_mapModelToEntity' ya no es necesario.
}