import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

/// El Caso de Uso (UseCase) para "Crear un Equipo".
class CreateEquipmentUseCase {
  final EquipmentRepository repository;

  CreateEquipmentUseCase(this.repository);

  /// El método `call` permite que el UseCase sea llamado como una función.
  Future<Either<Failure, EquipmentEntity>> call({
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
    // Simplemente reenvía los datos al repositorio
    return await repository.createEquipment(
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
  }
}