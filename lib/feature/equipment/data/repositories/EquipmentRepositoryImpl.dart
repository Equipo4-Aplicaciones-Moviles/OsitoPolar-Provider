import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/data/models/CreateEquipmentModel.dart';
import 'package:osito_polar_app/feature/equipment/data/datasource/EquipmentRemoteDataSource.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';
/// La "IMPLEMENTACIÓN" del contrato EquipmentRepository.
class EquipmentRepositoryImpl implements EquipmentRepository {
  final EquipmentRemoteDataSource remoteDataSource;
  final SharedPreferences prefs; // <-- Inyectado
  // TODO: Añadir localDataSource para caching si es necesario

  EquipmentRepositoryImpl({required this.remoteDataSource,required this.prefs,});

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

  @override
  Future<Either<Failure, EquipmentEntity>> createEquipment({
    required String name,
    required String type,
    required String model,
    required String serialNumber,
    required int ownerId,
    required String code,
    required String notes,
    required String ownerType,
    required String locationName,
    required String manufacturer,
    required String ownershipType,
    required String locationAddress,
    required String technicalDetails,
    required String energyConsumptionUnit,
    required double cost,
    required double currentTemperature,
    required double setTemperature,
    required double optimalTemperatureMin,
    required double optimalTemperatureMax,
    required double locationLatitude,
    required double locationLongitude,
    required double energyConsumptionCurrent,
    required double energyConsumptionAverage,
  }) async {
    try {
      // 1. Convierte los datos puros en el Modelo de Request
      final requestModel = CreateEquipmentModel(
        name: name,
        type: type,
        model: model,
        serialNumber: serialNumber,
        ownerId: ownerId,
        code: code,
        notes: notes,
        ownerType: ownerType,
        locationName: locationName,
        manufacturer: manufacturer,
        ownershipType: ownershipType,
        locationAddress: locationAddress,
        technicalDetails: technicalDetails,
        energyConsumptionUnit: energyConsumptionUnit,
        cost: cost,
        currentTemperature: currentTemperature,
        setTemperature: setTemperature,
        optimalTemperatureMin: optimalTemperatureMin,
        optimalTemperatureMax: optimalTemperatureMax,
        locationLatitude: locationLatitude,
        locationLongitude: locationLongitude,
        energyConsumptionCurrent: energyConsumptionCurrent,
        energyConsumptionAverage: energyConsumptionAverage,
      );


      // 2. Llama al "cartero" (DataSource)
      final newEquipmentModel = await remoteDataSource.createEquipment(requestModel);

      // 3. Mapea el Modelo (Respuesta de la API) a una Entidad (para la UI)
      final equipmentEntity = EquipmentEntity(
        id: newEquipmentModel.id,
        name: newEquipmentModel.name,
        type: newEquipmentModel.type,
        model: newEquipmentModel.model,
        serialNumber: newEquipmentModel.serialNumber,
        status: newEquipmentModel.status,
        currentTemperature: newEquipmentModel.currentTemperature,
        ownerId: newEquipmentModel.ownerId,
      );

      // 4. Retorna el éxito (Right)
      return Right(equipmentEntity);

    } on Exception {
      // 5. Si el "cartero" falla, retorna un fracaso (Left)
      return Left(ServerFailure());
    }
  }
}