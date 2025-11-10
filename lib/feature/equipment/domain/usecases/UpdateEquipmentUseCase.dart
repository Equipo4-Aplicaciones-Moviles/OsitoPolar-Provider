import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

/// El Caso de Uso (UseCase) para "Actualizar un Equipo".
class UpdateEquipmentUseCase {
  final EquipmentRepository repository;

  UpdateEquipmentUseCase(this.repository);

  /// El método `call` ahora toma el ID y el Map de datos.
  Future<Either<Failure, EquipmentEntity>> call(
      int equipmentId, Map<String, dynamic> equipmentData) async {
    // Simplemente reenvía los datos al repositorio
    return await repository.updateEquipment(equipmentId, equipmentData);
  }
}