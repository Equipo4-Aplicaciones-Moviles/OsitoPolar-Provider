import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/data/datasource/EquipmentRemoteDataSource.dart';
import 'package:osito_polar_app/feature/equipment/data/models/CreateEquipmentModel.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:osito_polar_app/feature/equipment/data/models/EquipmentModel.dart';


class EquipmentRepositoryImpl implements EquipmentRepository {
  final EquipmentRemoteDataSource remoteDataSource;
  final SharedPreferences prefs;

  EquipmentRepositoryImpl({
    required this.remoteDataSource,
    required this.prefs,
  });

  // --- ¡MAPEADO ACTUALIZADO! ---
  @override
  Future<Either<Failure, List<EquipmentEntity>>> getEquipments() async {
    print('--- Llamando al DataSource real para Equipos ---');
    try {
      final equipmentModels = await remoteDataSource.getEquipments();

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
        locationName: model.locationName,
        // --- ¡AÑADIDO! ---
        code: model.code,
        manufacturer: model.manufacturer,
        energyConsumptionCurrent: model.energyConsumptionCurrent,
        technicalDetails: model.technicalDetails,
        notes: model.notes,
      ))
          .toList();

      print('--- Llamada real exitosa. ${equipmentEntities.length} equipos encontrados. ---');
      return Right(equipmentEntities);

    } on Exception {
      return Left(ServerFailure());
    }
  }

  // --- ¡MAPEADO ACTUALIZADO! ---
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
        locationName: newEquipmentModel.locationName,
        // --- ¡AÑADIDO! ---
        code: newEquipmentModel.code,
        manufacturer: newEquipmentModel.manufacturer,
        energyConsumptionCurrent: newEquipmentModel.energyConsumptionCurrent,
        technicalDetails: newEquipmentModel.technicalDetails,
        notes: newEquipmentModel.notes,
      );

      // 4. Retorna el éxito (Right)
      return Right(equipmentEntity);
    } on Exception {
      // 5. Si el "cartero" falla, retorna un fracaso (Left)
      return Left(ServerFailure());
    }
  }

  // --- ¡MAPEADO ACTUALIZADO! ---
  @override
  Future<Either<Failure, EquipmentEntity>> getEquipmentById(int equipmentId) async {
    try {
      // 1. Llama al "cartero" (DataSource)
      final equipmentModel = await remoteDataSource.getEquipmentById(equipmentId);

      // 2. Mapea el Modelo (Data) a una Entidad (Domain)
      final equipmentEntity = EquipmentEntity(
        id: equipmentModel.id,
        name: equipmentModel.name,
        type: equipmentModel.type,
        model: equipmentModel.model,
        serialNumber: equipmentModel.serialNumber,
        status: equipmentModel.status,
        currentTemperature: equipmentModel.currentTemperature,
        ownerId: equipmentModel.ownerId,
        locationName: equipmentModel.locationName,
        // --- ¡AÑADIDO! ---
        code: equipmentModel.code,
        manufacturer: equipmentModel.manufacturer,
        energyConsumptionCurrent: equipmentModel.energyConsumptionCurrent,
        technicalDetails: equipmentModel.technicalDetails,
        notes: equipmentModel.notes,
      );

      // 3. Retorna el éxito (Right)
      return Right(equipmentEntity);
    } on Exception {
      // 4. Si el "cartero" falla, retorna un fracaso (Left)
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteEquipment(int equipmentId) async {
    try {
      // 1. Llama al "cartero" (DataSource) para borrar
      //    (No esperamos respuesta, es 'void')
      await remoteDataSource.deleteEquipment(equipmentId);

      // 2. Retorna el éxito (Right)
      return const Right(null); // 'null' representa 'void'
    } on Exception {
      // 3. Si el "cartero" falla, retorna un fracaso (Left)
      return Left(ServerFailure());
    }
  }
}