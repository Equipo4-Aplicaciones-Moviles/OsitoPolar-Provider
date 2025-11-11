import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';

/// El "CONTRATO" (Interfaz) para el Repositorio de Equipos.
abstract class EquipmentRepository {
  /// Obtiene la lista de equipos del 'Provider' (Empresa)
  Future<Either<Failure, List<EquipmentEntity>>> getEquipments();
  Future<Either<Failure, EquipmentEntity>> getEquipmentById(int equipmentId);

// TODO: Añadir getEquipmentById, etc.
  Future<Either<Failure, EquipmentEntity>> createEquipment(
      Map<String, dynamic> equipmentData);


  Future<Either<Failure, void>> deleteEquipment(int equipmentId);
  Future<Either<Failure, EquipmentEntity>> updateEquipment(
      int equipmentId, Map<String, dynamic> equipmentData);
}