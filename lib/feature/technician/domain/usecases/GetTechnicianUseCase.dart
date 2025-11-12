import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import 'package:osito_polar_app/feature/technician/domain/entities/TechnicianEntity.dart';
import 'package:osito_polar_app/feature/technician/domain/repositories/TechnicianRepository.dart';

/// Implementa el "molde" UseCase y le dice:
/// 1. El tipo de Éxito es: List<TechnicianEntity>
/// 2. El tipo de Parámetro es: NoParams (porque no necesita un ID)
class GetTechniciansUseCase implements UseCase<List<TechnicianEntity>, NoParams> {

  final TechnicianRepository repository;

  GetTechniciansUseCase(this.repository);

  /// Llama al método del repositorio que obtiene la lista de técnicos.
  @override
  Future<Either<Failure, List<TechnicianEntity>>> call(NoParams params) async {
    return await repository.getTechnicians();
  }
}