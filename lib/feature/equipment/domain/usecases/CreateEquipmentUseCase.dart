import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

// Nota: Usamos un 'Map<String, dynamic>' como 'Params'
// porque así es como tu AddEquipmentProvider lo está llamando.
//
// Devuelve: La entidad del equipo recién creado.
class CreateEquipmentUseCase implements UseCase<EquipmentEntity, Map<String, dynamic>> {
  final EquipmentRepository repository;

  CreateEquipmentUseCase(this.repository);

  @override
  Future<Either<Failure, EquipmentEntity>> call(Map<String, dynamic> params) async {
    // Simplemente reenvía el Map al repositorio
    return await repository.createEquipment(params);
  }
}