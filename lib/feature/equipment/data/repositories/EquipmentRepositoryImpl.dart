import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/data/datasource/EquipmentRemoteDataSource.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

/// La "IMPLEMENTACIÓN" del contrato EquipmentRepository.
class EquipmentRepositoryImpl implements EquipmentRepository {
  final EquipmentRemoteDataSource remoteDataSource;
  // TODO: Añadir localDataSource para caching si es necesario

  EquipmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<EquipmentEntity>>> getEquipments() async {
    try {
      // 1. Llama al "cartero" (DataSource) para obtener los Modelos (con JSON)
      final equipmentModels = await remoteDataSource.getEquipments();

      // 2. Mapea la lista de Modelos (Data) a Entidades (Domain)
      //    Esto es clave para desacoplar las capas.
      final equipmentEntities = equipmentModels
          .map((model) => EquipmentEntity(
        id: model.id,
        name: model.name,
        type: model.type,
        model: model.model,
        serialNumber: model.serialNumber,
        status: model.status,
        currentTemperature: model.currentTemperature,
        ownerId: model.ownerId,
      ))
          .toList();

      // 3. Retorna el éxito (Right) con la lista de Entidades Puras
      return Right(equipmentEntities);
    } on Exception {
      // 4. Si el "cartero" falla, retorna un fracaso (Left)
      // TODO: Manejar diferentes excepciones (ServerException, NetworkException)
      return Left(ServerFailure());
    }
  }
}