import 'dart:convert';
import 'package:osito_polar_app/feature/service_request/domain/entities/ServiceRequestEntity.dart';

// Este modelo hereda de la Entidad
class ServiceRequestModel extends ServiceRequestEntity {

  const ServiceRequestModel({
    required super.id,
    required super.title,
    required super.status,
    super.clientId,
  });

  factory ServiceRequestModel.fromJson(String str) =>
      ServiceRequestModel.fromMap(json.decode(str));

  // --- ¡¡AQUÍ ESTÁ EL ARREGLO!! ---
  // Este factory ahora SÍ coincide con el JSON de tu log
  factory ServiceRequestModel.fromMap(Map<String, dynamic> json) {
    return ServiceRequestModel(
      // Campos que tu UI SÍ necesita:
      id: json['id'],
      title: json['title'] ?? 'Sin Título', // 'title' es un String
      status: json['status'] ?? 'Desconocido', // 'status' es un String
      clientId: json['clientId'], // 'clientId' es un int (Ej: 3)

      // ¡Importante!
      // Ignoramos el campo "equipment" (el Map) que estaba
      // causando el crash. Ya no intentamos leerlo.
      // También ignoramos 'equipmentId', 'description', etc.,
      // porque tu UI no los está usando por ahora.
    );
  }

  // Método estático para parsear la lista completa
  static List<ServiceRequestModel> listFromJson(String str) =>
      List<ServiceRequestModel>.from(json.decode(str).map((x) => ServiceRequestModel.fromMap(x)));

}