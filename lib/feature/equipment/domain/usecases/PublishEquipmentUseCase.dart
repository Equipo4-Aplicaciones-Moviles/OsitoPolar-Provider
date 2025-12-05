import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

// Devuelve: El equipo actualizado (ahora publicado).
class PublishEquipmentUseCase implements UseCase<EquipmentEntity, PublishEquipmentParams> {
  final EquipmentRepository repository;

  PublishEquipmentUseCase(this.repository);

  @override
  Future<Either<Failure, EquipmentEntity>> call(PublishEquipmentParams params) async {
    return await repository.publishEquipment(
      equipmentId: params.equipmentId,
      monthlyFee: params.monthlyFee,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

// Objeto 'Params' para pasar los datos que la API necesita para publicar.
// (Basado en el schema 'PublishForRentResource')
class PublishEquipmentParams extends Equatable {
  final int equipmentId;
  final double monthlyFee;
  final DateTime startDate;
  final DateTime endDate;

  const PublishEquipmentParams({
    required this.equipmentId,
    required this.monthlyFee,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [equipmentId, monthlyFee, startDate, endDate];
}