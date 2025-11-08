import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

/// El Caso de Uso (UseCase) para "Obtener Equipos".
class GetEquipmentsUseCase {
  final EquipmentRepository repository;

  GetEquipmentsUseCase(this.repository);

  /// El método `call` permite que el UseCase sea llamado como una función.
  Future<Either<Failure, List<EquipmentEntity>>> call() async {
    // Simplemente llama al repositorio
    return await repository.getEquipments();
  }
}