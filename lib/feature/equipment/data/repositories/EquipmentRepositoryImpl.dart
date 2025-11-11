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
        ownershipType: model.ownershipType,
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
  Future<Either<Failure, EquipmentEntity>> createEquipment(
      Map<String, dynamic> equipmentData) async {
    try {
      // 1. Convierte el Map del formulario en el Modelo de Request
      final requestModel = CreateEquipmentModel(
        name: equipmentData['name'],
        type: equipmentData['type'],
        model: equipmentData['model'],
        serialNumber: equipmentData['serialNumber'],
        ownerId: equipmentData['ownerId'],
        code: equipmentData['code'],
        notes: equipmentData['notes'],
        ownerType: equipmentData['ownerType'],
        locationName: equipmentData['locationName'],
        manufacturer: equipmentData['manufacturer'],
        ownershipType: equipmentData['ownershipType'],
        locationAddress: equipmentData['locationAddress'],
        technicalDetails: equipmentData['technicalDetails'],
        energyConsumptionUnit: equipmentData['energyConsumptionUnit'],
        cost: equipmentData['cost'],
        currentTemperature: equipmentData['currentTemperature'],
        setTemperature: equipmentData['setTemperature'],
        optimalTemperatureMin: equipmentData['optimalTemperatureMin'],
        optimalTemperatureMax: equipmentData['optimalTemperatureMax'],
        locationLatitude: equipmentData['locationLatitude'],
        locationLongitude: equipmentData['locationLongitude'],
        energyConsumptionCurrent: equipmentData['energyConsumptionCurrent'],
        energyConsumptionAverage: equipmentData['energyConsumptionAverage'],
      );

      // 2. Llama al "cartero" (DataSource)
      final newEquipmentModel =
      await remoteDataSource.createEquipment(requestModel);

      // 3. Mapea el Modelo a una Entidad
      final equipmentEntity = _mapModelToEntity(newEquipmentModel);

      // 4. Retorna el éxito (Right)
      return Right(equipmentEntity);
    } on Exception {
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
        ownershipType: equipmentModel.ownershipType,
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


  // --- ¡MÉTODO AÑADIDO! ---
  @override
  Future<Either<Failure, EquipmentEntity>> updateEquipment(
      int equipmentId, Map<String, dynamic> equipmentData) async {
    try {
      // 1. Convierte el Map del formulario en el Modelo de Request
      //    (Reutilizamos el 'CreateEquipmentModel' para el PUT)
      final requestModel = CreateEquipmentModel(
        name: equipmentData['name'],
        type: equipmentData['type'],
        model: equipmentData['model'],
        serialNumber: equipmentData['serialNumber'],
        ownerId: equipmentData['ownerId'],
        code: equipmentData['code'],
        notes: equipmentData['notes'],
        ownerType: equipmentData['ownerType'],
        locationName: equipmentData['locationName'],
        manufacturer: equipmentData['manufacturer'],
        ownershipType: equipmentData['ownershipType'],
        locationAddress: equipmentData['locationAddress'],
        technicalDetails: equipmentData['technicalDetails'],
        energyConsumptionUnit: equipmentData['energyConsumptionUnit'],
        cost: equipmentData['cost'],
        currentTemperature: equipmentData['currentTemperature'],
        setTemperature: equipmentData['setTemperature'],
        optimalTemperatureMin: equipmentData['optimalTemperatureMin'],
        optimalTemperatureMax: equipmentData['optimalTemperatureMax'],
        locationLatitude: equipmentData['locationLatitude'],
        locationLongitude: equipmentData['locationLongitude'],
        energyConsumptionCurrent: equipmentData['energyConsumptionCurrent'],
        energyConsumptionAverage: equipmentData['energyConsumptionAverage'],
      );

      // 2. Llama al "cartero" (DataSource) con el ID
      final updatedEquipmentModel =
      await remoteDataSource.updateEquipment(equipmentId, requestModel);

      // 3. Mapea el Modelo a una Entidad
      final equipmentEntity = _mapModelToEntity(updatedEquipmentModel);

      // 4. Retorna el éxito (Right)
      return Right(equipmentEntity);
    } on Exception {
      return Left(ServerFailure());
    }
  }

  // --- ¡HELPER AÑADIDO! ---
  /// Helper privado para mapear un Modelo (Data) a una Entidad (Domain)
  EquipmentEntity _mapModelToEntity(EquipmentModel model) {
    return EquipmentEntity(
      id: model.id,
      name: model.name,
      type: model.type,
      model: model.model,
      serialNumber: model.serialNumber,
      status: model.status,
      currentTemperature: model.currentTemperature,
      ownerId: model.ownerId,
      locationName: model.locationName,
      code: model.code,
      manufacturer: model.manufacturer,
      energyConsumptionCurrent: model.energyConsumptionCurrent,
      technicalDetails: model.technicalDetails,
      notes: model.notes,
      ownershipType: model.ownershipType,
    );
  }
}