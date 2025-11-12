import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

// Usa un 'int' (el ID) como 'Params'.
// Devuelve: La entidad del equipo encontrado.
class GetEquipmentByIdUseCase implements UseCase<EquipmentEntity, int> {
  final EquipmentRepository repository;

  GetEquipmentByIdUseCase(this.repository);

  @override
  Future<Either<Failure, EquipmentEntity>> call(int id) async {
    return await repository.getEquipmentById(id);
  }
}