import 'package:osito_polar_app/feature/equipment/data/models/EquipmentModel.dart';
import 'package:osito_polar_app/feature/equipment/data/models/CreateEquipmentModel.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentReadingEntity.dart';

import '../models/EquipmentHealthModel.dart';
import '../models/EquipmentOperationModel.dart';
import '../models/EquipmentReadingModel.dart';
/// Interfaz (Contrato) para la fuente de datos remota de Equipos.
abstract class EquipmentRemoteDataSource {
  /// Llama al endpoint GET /api/v1/equipments
  ///
  /// Arroja una [Exception] si falla la llamada.
  Future<List<EquipmentModel>> getEquipments();

  /// Llama al endpoint POST /api/v1/equipments
  Future<EquipmentModel> createEquipment(CreateEquipmentModel equipment);

  /// Llama al endpoint GET /api/v1/equipments/{equipmentId}
  Future<EquipmentModel> getEquipmentById(int equipmentId);


  /// Llama al endpoint DELETE /api/v1/equipments/{equipmentId}
  Future<void> deleteEquipment(int equipmentId);
  Future<EquipmentModel> updateEquipment(
      int equipmentId, CreateEquipmentModel equipment);

  Future<EquipmentModel> publishEquipment({
    required int equipmentId,
    required double monthlyFee,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Llama a: DELETE /api/v1/equipments/{id}/rental
  Future<EquipmentModel> unpublishEquipment({
    required int equipmentId,
  });

  Future<EquipmentHealthModel> getEquipmentHealth({
    required int equipmentId,
    required int days,
  });


  Future<List<EquipmentReadingModel>> getEquipmentReadings({
    required int equipmentId,
    required int hours,
  });

  /// Controla el equipo (Temperatura, Encendido/Apagado)
  Future<EquipmentModel> updateEquipmentOperations({
    required int equipmentId,
    required EquipmentOperationModel operations,
  });

// TODO: Añadir métodos para getEquipmentById, createEquipment, etc.
}