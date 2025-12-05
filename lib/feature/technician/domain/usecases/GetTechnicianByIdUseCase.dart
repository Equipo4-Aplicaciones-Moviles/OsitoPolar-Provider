import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import 'package:osito_polar_app/feature/technician/domain/entities/TechnicianEntity.dart';
import 'package:osito_polar_app/feature/technician/domain/repositories/TechnicianRepository.dart';

/// Implementa el "molde" UseCase y le dice:
/// 1. El tipo de Éxito es: TechnicianEntity (un solo técnico)
/// 2. El tipo de Parámetro es: int (el ID del técnico a buscar)
class GetTechnicianByIdUseCase implements UseCase<TechnicianEntity, int> {

  final TechnicianRepository repository;

  GetTechnicianByIdUseCase(this.repository);

  /// Llama al método del repositorio que obtiene el técnico por su ID.
  @override
  Future<Either<Failure, TechnicianEntity>> call(int technicianId) async {
    return await repository.getTechnicianById(technicianId);
  }
}