import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import 'package:osito_polar_app/feature/technician/domain/entities/TechnicianEntity.dart';
import 'package:osito_polar_app/feature/technician/domain/repositories/TechnicianRepository.dart';

/// Implementa el "molde" UseCase y le dice:
/// 1. El tipo de Éxito es: TechnicianEntity (la API devuelve el técnico creado)
/// 2. El tipo de Parámetro es: Map<String, dynamic> (los datos del formulario)
class CreateTechnicianUseCase implements UseCase<TechnicianEntity, Map<String, dynamic>> {

  final TechnicianRepository repository;

  CreateTechnicianUseCase(this.repository);

  /// Llama al método del repositorio que crea el técnico.
  @override
  Future<Either<Failure, TechnicianEntity>> call(Map<String, dynamic> params) async {
    return await repository.createTechnician(technicianData: params);
  }
}