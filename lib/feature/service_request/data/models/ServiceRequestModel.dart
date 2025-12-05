import 'dart:convert';
import 'package:osito_polar_app/feature/service_request/domain/entities/ServiceRequestEntity.dart';

class ServiceRequestModel extends ServiceRequestEntity {

  const ServiceRequestModel({
    required super.id,
    required super.title,
    required super.status,
    super.clientId,
    // --- Nuevos campos ---
    required super.urgency,
    super.serviceType,
    super.scheduledDate,
    super.timeSlot,
    super.serviceAddress,
    super.description,
  });

  factory ServiceRequestModel.fromJson(String str) =>
      ServiceRequestModel.fromMap(json.decode(str));

  factory ServiceRequestModel.fromMap(Map<String, dynamic> json) {
    return ServiceRequestModel(
      // Campos básicos
      id: json['id'],
      title: json['title'] ?? 'Sin Título',
      status: json['status'] ?? 'Pending',
      clientId: json['clientId'],

      // --- MAPEAMOS LOS NUEVOS DATOS DEL JSON ---

      // Urgencia: Si viene nulo, asumimos 'low' para que no rompa el color
      urgency: json['urgency'] ?? 'low',

      // Tipo de servicio
      serviceType: json['serviceType'],

      // Fecha: Convertimos el String ISO8601 a DateTime
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.tryParse(json['scheduledDate'])
          : null,

      // Hora
      timeSlot: json['timeSlot'],

      // Dirección
      serviceAddress: json['serviceAddress'],

      // Descripción
      description: json['description'],
    );
  }

  static List<ServiceRequestModel> listFromJson(String str) =>
      List<ServiceRequestModel>.from(json.decode(str).map((x) => ServiceRequestModel.fromMap(x)));
}