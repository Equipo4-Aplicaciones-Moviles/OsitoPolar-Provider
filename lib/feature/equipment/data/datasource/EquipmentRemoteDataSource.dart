import 'package:osito_polar_app/feature/equipment/data/models/EquipmentModel.dart';
import 'package:osito_polar_app/feature/equipment/data/models/CreateEquipmentModel.dart';
/// Interfaz (Contrato) para la fuente de datos remota de Equipos.
abstract class EquipmentRemoteDataSource {
  /// Llama al endpoint GET /api/v1/equipments
  ///
  /// Arroja una [Exception] si falla la llamada.
  Future<List<EquipmentModel>> getEquipments();

  /// Llama al endpoint POST /api/v1/equipments
  Future<EquipmentModel> createEquipment(CreateEquipmentModel equipment);

// TODO: Añadir métodos para getEquipmentById, createEquipment, etc.
}