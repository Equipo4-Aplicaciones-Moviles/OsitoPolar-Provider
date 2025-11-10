import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';

/// El "CONTRATO" (Interfaz) para el Repositorio de Equipos.
abstract class EquipmentRepository {
  /// Obtiene la lista de equipos del 'Provider' (Empresa)
  Future<Either<Failure, List<EquipmentEntity>>> getEquipments();
  Future<Either<Failure, EquipmentEntity>> getEquipmentById(int equipmentId);

// TODO: Añadir getEquipmentById, etc.
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
  });

  Future<Either<Failure, void>> deleteEquipment(int equipmentId);

}