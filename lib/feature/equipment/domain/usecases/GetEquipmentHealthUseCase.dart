import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentHealthEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

class GetEquipmentHealthUseCase implements UseCase<EquipmentHealthEntity, GetHealthParams> {
  final EquipmentRepository repository;

  GetEquipmentHealthUseCase(this.repository);

  @override
  Future<Either<Failure, EquipmentHealthEntity>> call(GetHealthParams params) async {
    return await repository.getEquipmentHealth(
      equipmentId: params.equipmentId,
      days: params.days,
    );
  }
}

class GetHealthParams extends Equatable {
  final int equipmentId;
  final int days;

  const GetHealthParams({
    required this.equipmentId,
    required this.days,
  });

  @override
  List<Object> get props => [equipmentId, days];
}