import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

class UpdateEquipmentOperationUseCase implements UseCase<EquipmentEntity, UpdateOperationParams> {
  final EquipmentRepository repository;

  UpdateEquipmentOperationUseCase(this.repository);

  @override
  Future<Either<Failure, EquipmentEntity>> call(UpdateOperationParams params) async {
    // Nota: Asegúrate de agregar 'updateEquipmentOperations' en tu EquipmentRepository
    return await repository.updateEquipmentOperations(
      equipmentId: params.equipmentId,
      temperature: params.temperature,
      powerState: params.powerState,
    );
  }
}

class UpdateOperationParams extends Equatable {
  final int equipmentId;
  final double? temperature;
  final String? powerState;

  const UpdateOperationParams({
    required this.equipmentId,
    this.temperature,
    this.powerState,
  });

  @override
  List<Object?> get props => [equipmentId, temperature, powerState];
}