import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/technician/domain/entities/TechnicianEntity.dart';

abstract class TechnicianRepository {

  /// Llama a: GET /api/v1/technicians
  /// Obtiene la lista de todos los técnicos de nuestra compañía.
  Future<Either<Failure, List<TechnicianEntity>>> getTechnicians();

  /// Llama a: POST /api/v1/technicians
  /// Crea un nuevo técnico.
  /// Nota: El 'data' es un Map porque lo enviaremos desde un formulario.
  Future<Either<Failure, TechnicianEntity>> createTechnician(
      {required Map<String, dynamic> technicianData});

// (En el futuro, podríamos añadir: updateTechnician, deleteTechnician, etc.)
}