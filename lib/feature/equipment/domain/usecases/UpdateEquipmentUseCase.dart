import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

// Devuelve: La entidad del equipo actualizado.
class UpdateEquipmentUseCase implements UseCase<EquipmentEntity, UpdateEquipmentParams> {
  final EquipmentRepository repository;

  UpdateEquipmentUseCase(this.repository);

  @override
  Future<Either<Failure, EquipmentEntity>> call(UpdateEquipmentParams params) async {
    return await repository.updateEquipment(params.id, params.data);
  }
}

// Objeto 'Params' para pasar tanto el ID como el Map de datos.
class UpdateEquipmentParams extends Equatable {
  final int id;
  final Map<String, dynamic> data;

  const UpdateEquipmentParams({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}