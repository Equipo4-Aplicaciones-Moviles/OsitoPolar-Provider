
import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

// Usa un 'int' (el ID) como 'Params'.
// Devuelve: El equipo actualizado (ahora oculto).
class UnpublishEquipmentUseCase implements UseCase<EquipmentEntity, int> {
  final EquipmentRepository repository;

  UnpublishEquipmentUseCase(this.repository);

  @override
  Future<Either<Failure, EquipmentEntity>> call(int equipmentId) async {
    return await repository.unpublishEquipment(equipmentId: equipmentId);
  }
}