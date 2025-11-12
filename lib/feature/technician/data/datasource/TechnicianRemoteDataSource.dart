import 'package:osito_polar_app/feature/technician/data/models/TechnicianModel.dart';

abstract class TechnicianRemoteDataSource {

  /// Llama a: GET /api/v1/technicians
  /// Arroja [ServerException] si falla.
  Future<List<TechnicianModel>> getTechnicians();

  /// Llama a: POST /api/v1/technicians
  /// Arroja [ServerException] si falla.
  Future<TechnicianModel> createTechnician(
      {required Map<String, dynamic> technicianData});
}