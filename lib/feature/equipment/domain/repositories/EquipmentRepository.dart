import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';

/// El "CONTRATO" (Interfaz) para el Repositorio de Equipos.
abstract class EquipmentRepository {
  /// Obtiene la lista de equipos del 'Provider' (Empresa)
  Future<Either<Failure, List<EquipmentEntity>>> getEquipments();

// TODO: Añadir getEquipmentById, etc.
}