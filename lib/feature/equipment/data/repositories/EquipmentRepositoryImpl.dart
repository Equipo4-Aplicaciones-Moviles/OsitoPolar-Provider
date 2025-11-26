import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/error/Exceptions.dart';

import 'package:osito_polar_app/feature/equipment/data/datasource/EquipmentRemoteDataSource.dart';
import 'package:osito_polar_app/feature/equipment/data/models/CreateEquipmentModel.dart';
import 'package:osito_polar_app/feature/equipment/data/models/EquipmentModel.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

class EquipmentRepositoryImpl implements EquipmentRepository {
  final EquipmentRemoteDataSource remoteDataSource;
  final SharedPreferences prefs;

  EquipmentRepositoryImpl({
    required this.remoteDataSource,
    required this.prefs,
  });

  @override
  Future<Either<Failure, List<EquipmentEntity>>> getEquipments() async {
    try {
      final equipmentModels = await remoteDataSource.getEquipments();

      // --- ¡AQUÍ ESTÁ EL CAMBIO! ---
      // Usamos el método .toEntity() del modelo.
      // Como el modelo ya sabe leer 'rentalInfo', la entidad también lo tendrá.
      final equipmentEntities = equipmentModels
          .map((model) => model.toEntity())
          .toList();

      return Right(equipmentEntities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EquipmentEntity>> getEquipmentById(int equipmentId) async {
    try {
      final equipmentModel = await remoteDataSource.getEquipmentById(equipmentId);
      return Right(equipmentModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EquipmentEntity>> createEquipment(
      Map<String, dynamic> equipmentData) async {
    try {
      // Convertimos el Map del formulario al Modelo que pide la API
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

      final newEquipmentModel =
      await remoteDataSource.createEquipment(requestModel);

      return Right(newEquipmentModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EquipmentEntity>> updateEquipment(
      int equipmentId, Map<String, dynamic> equipmentData) async {
    try {
      // Reutilizamos CreateEquipmentModel para el Update (PUT)
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

      final updatedEquipmentModel =
      await remoteDataSource.updateEquipment(equipmentId, requestModel);

      return Right(updatedEquipmentModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEquipment(int equipmentId) async {
    try {
      await remoteDataSource.deleteEquipment(equipmentId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EquipmentEntity>> publishEquipment({
    required int equipmentId,
    required double monthlyFee,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final equipmentModel = await remoteDataSource.publishEquipment(
        equipmentId: equipmentId,
        monthlyFee: monthlyFee,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(equipmentModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EquipmentEntity>> unpublishEquipment({
    required int equipmentId,
  }) async {
    try {
      final equipmentModel = await remoteDataSource.unpublishEquipment(
        equipmentId: equipmentId,
      );
      return Right(equipmentModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}