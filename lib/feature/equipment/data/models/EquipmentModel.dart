import 'dart:convert';

// Basado en el schema 'EquipmentResource' de tu API (Swagger)
class EquipmentModel {
  final int id;
  final String name;
  final String type;
  final String model;
  final String serialNumber;
  final String status;
  final double currentTemperature;
  final int ownerId;

  EquipmentModel({
    required this.id,
    required this.name,
    required this.type,
    required this.model,
    required this.serialNumber,
    required this.status,
    required this.currentTemperature,
    required this.ownerId,
  });

  factory EquipmentModel.fromJson(String str) =>
      EquipmentModel.fromMap(json.decode(str));

  factory EquipmentModel.fromMap(Map<String, dynamic> json) => EquipmentModel(
    // Asegúrate de que los nombres 'json['...']' coincidan EXACTAMENTE
    // con los de tu API (pueden ser camelCase como 'serialNumber')
    id: json['id'],
    name: json['name'] ?? 'Nombre no disponible',
    type: json['type'] ?? 'N/A',
    model: json['model'] ?? 'N/A',
    serialNumber: json['serialNumber'] ?? 'N/A',
    status: json['status'] ?? 'Desconocido',
    currentTemperature: json['currentTemperature']?.toDouble() ?? 0.0,
    ownerId: json['ownerId'] ?? 0,
  );

  // Helper para convertir una lista de JSONs (la respuesta de la API)
  // en una Lista de EquipmentModel
  static List<EquipmentModel> listFromMap(List<dynamic> list) =>
      List<EquipmentModel>.from(list.map((x) => EquipmentModel.fromMap(x)));

  static List<EquipmentModel> listFromJson(String str) =>
      listFromMap(json.decode(str));
}