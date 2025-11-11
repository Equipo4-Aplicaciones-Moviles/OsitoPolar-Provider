import 'package:osito_polar_app/feature/service_request/data/models/ServiceRequestModel.dart';

/// Interfaz (Contrato) para la fuente de datos remota de Solicitudes de Servicio.
abstract class ServiceRequestRemoteDataSource {
  /// Llama al endpoint GET /api/v1/service-requests
  ///
  /// Arroja una [Exception] si falla la llamada.
  Future<List<ServiceRequestModel>> getServiceRequests();

// TODO: Añadir métodos para getServiceRequestById, createServiceRequest, etc.
}