import 'dart:convert';

// Basado en el schema 'ServiceRequestResource' de tu API (Swagger)
class ServiceRequestModel {
  final int id;
  final String orderNumber;
  final String title;
  final String description;
  final String issueDetails;
  final int? clientId;
  final int? companyId;
  final int equipmentId;
  final String requestTime;
  final String status;
  final String priority;
  final String serviceType;
  final bool isEmergency;

  ServiceRequestModel({
    required this.id,
    required this.orderNumber,
    required this.title,
    required this.description,
    required this.issueDetails,
    this.clientId,
    this.companyId,
    required this.equipmentId,
    required this.requestTime,
    required this.status,
    required this.priority,
    required this.serviceType,
    required this.isEmergency,
  });

  factory ServiceRequestModel.fromJson(String str) =>
      ServiceRequestModel.fromMap(json.decode(str));

  factory ServiceRequestModel.fromMap(Map<String, dynamic> json) =>
      ServiceRequestModel(
        // Asegúrate de que los nombres 'json['...']' coincidan con tu API
        id: json['id'],
        orderNumber: json['orderNumber'] ?? 'N/A',
        title: json['title'] ?? 'Sin Título',
        description: json['description'] ?? '',
        issueDetails: json['issueDetails'] ?? '',
        clientId: json['clientId'],
        companyId: json['companyId'],
        equipmentId: json['equipmentId'],
        requestTime: json['requestTime'] ?? '',
        status: json['status'] ?? 'Desconocido',
        priority: json['priority'] ?? 'Normal',
        serviceType: json['serviceType'] ?? 'N/A',
        isEmergency: json['isEmergency'] ?? false,
      );

  static List<ServiceRequestModel> listFromMap(List<dynamic> list) =>
      List<ServiceRequestModel>.from(
          list.map((x) => ServiceRequestModel.fromMap(x)));

  static List<ServiceRequestModel> listFromJson(String str) =>
      listFromMap(json.decode(str));
}