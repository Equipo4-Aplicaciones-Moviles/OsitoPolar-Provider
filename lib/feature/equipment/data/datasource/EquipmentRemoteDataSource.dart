import 'package:osito_polar_app/feature/equipment/data/models/EquipmentModel.dart';

/// Interfaz (Contrato) para la fuente de datos remota de Equipos.
abstract class EquipmentRemoteDataSource {
  /// Llama al endpoint GET /api/v1/equipments
  ///
  /// Arroja una [Exception] si falla la llamada.
  Future<List<EquipmentModel>> getEquipments();

// TODO: Añadir métodos para getEquipmentById, createEquipment, etc.
}