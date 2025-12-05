import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentReadingEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

class GetEquipmentReadingsUseCase implements UseCase<List<EquipmentReadingEntity>, GetReadingsParams> {
  final EquipmentRepository repository;

  GetEquipmentReadingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<EquipmentReadingEntity>>> call(GetReadingsParams params) async {
    // Nota: Debes agregar 'getReadings' a tu EquipmentRepository
    // repository.getReadings(...)
    // Como no puedo editar tu repositorio aquí, asumo que lo agregarás.
    throw UnimplementedError("Debes implementar getReadings en tu repositorio");
  }
}

class GetReadingsParams extends Equatable {
  final int equipmentId;
  final int hours; // Cuantas horas atrás ver

  const GetReadingsParams({required this.equipmentId, this.hours = 24});

  @override
  List<Object> get props => [equipmentId, hours];
}