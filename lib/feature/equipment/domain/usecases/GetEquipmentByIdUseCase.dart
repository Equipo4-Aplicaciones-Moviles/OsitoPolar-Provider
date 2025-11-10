import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

/// El Caso de Uso (UseCase) para "Obtener un Equipo por ID".
class GetEquipmentByIdUseCase {
  final EquipmentRepository repository;

  GetEquipmentByIdUseCase(this.repository);

  /// El método `call` ahora toma un ID.
  Future<Either<Failure, EquipmentEntity>> call(int equipmentId) async {
    return await repository.getEquipmentById(equipmentId);
  }
}