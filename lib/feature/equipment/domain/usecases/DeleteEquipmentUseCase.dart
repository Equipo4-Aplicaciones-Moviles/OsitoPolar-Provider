import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

/// El Caso de Uso (UseCase) para "Borrar un Equipo".
class DeleteEquipmentUseCase {
  final EquipmentRepository repository;

  DeleteEquipmentUseCase(this.repository);

  /// El método `call` ahora toma un ID.
  Future<Either<Failure, void>> call(int equipmentId) async {
    return await repository.deleteEquipment(equipmentId);
  }
}