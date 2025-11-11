import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

/// El Caso de Uso (UseCase) para "Crear un Equipo".
class CreateEquipmentUseCase {
  final EquipmentRepository repository;

  CreateEquipmentUseCase(this.repository);

  Future<Either<Failure, EquipmentEntity>> call(
      Map<String, dynamic> equipmentData) async {
    // Simplemente reenvía los datos al repositorio
    return await repository.createEquipment(equipmentData);
  }
}