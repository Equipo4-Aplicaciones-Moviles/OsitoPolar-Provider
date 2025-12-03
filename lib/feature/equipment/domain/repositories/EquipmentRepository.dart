import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentReadingEntity.dart';

import '../entities/EquipmentHealthEntity.dart';

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

  Future<Either<Failure, EquipmentEntity>> publishEquipment({
    required int equipmentId,
    required double monthlyFee,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Oculta (Unpublish) un equipo del marketplace de alquiler.
  /// Llama a DELETE /api/v1/equipments/{id}/rental
  Future<Either<Failure, EquipmentEntity>> unpublishEquipment({
    required int equipmentId,
  });

  Future<Either<Failure, EquipmentHealthEntity>> getEquipmentHealth({
    required int equipmentId,
    required int days,
  });

  Future<Either<Failure, List<EquipmentReadingEntity>>> getEquipmentReadings({
    required int equipmentId,
    required int hours,
  });

  // --- ¡CORREGIDO! MÉTODO PARA ACTUALIZAR OPERACIONES ---
  // Debe devolver EquipmentEntity (el equipo actualizado) y recibir los parámetros opcionales.
  Future<Either<Failure, EquipmentEntity>> updateEquipmentOperations({
    required int equipmentId,
    double? temperature,
    String? powerState,
  });
}