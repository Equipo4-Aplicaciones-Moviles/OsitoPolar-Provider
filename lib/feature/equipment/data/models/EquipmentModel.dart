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
  final String locationName;

  // --- ¡CAMPOS AÑADIDOS! ---
  final String code;
  final String manufacturer;
  final double energyConsumptionCurrent;
  final String technicalDetails;
  final String notes;// (Tu API lo tiene)
  final String ownershipType;

  EquipmentModel({
    required this.id,
    required this.name,
    required this.type,
    required this.model,
    required this.serialNumber,
    required this.status,
    required this.currentTemperature,
    required this.ownerId,
    required this.locationName,
    // --- ¡AÑADIDO! ---
    required this.code,
    required this.manufacturer,
    required this.energyConsumptionCurrent,
    required this.technicalDetails,
    required this.notes,
    required this.ownershipType,

  });

  factory EquipmentModel.fromJson(String str) =>
      EquipmentModel.fromMap(json.decode(str));

  factory EquipmentModel.fromMap(Map<String, dynamic> json) => EquipmentModel(
    id: json['id'],
    name: json['name'] ?? 'Nombre no disponible',
    type: json['type'] ?? 'N/A',
    model: json['model'] ?? 'N/A',
    serialNumber: json['serialNumber'] ?? 'N/A',
    status: json['status'] ?? 'Desconocido',
    currentTemperature: json['currentTemperature']?.toDouble() ?? 0.0,
    ownerId: json['ownerId'] ?? 0,
    locationName: json['locationName'] ?? 'Ubicación desconocida',

    // --- ¡AÑADIDO! ---
    // (Mapeamos los nuevos campos desde el JSON de la API)
    code: json['code'] ?? 'N/A',
    manufacturer: json['manufacturer'] ?? 'N/A',
    energyConsumptionCurrent: json['energyConsumptionCurrent']?.toDouble() ?? 0.0,
    technicalDetails: json['technicalDetails'] ?? 'N/A',
    notes: json['notes'] ?? 'N/A',
    ownershipType: json['ownershipType'] ?? 'Owned', // <-- Añadido
  );

  static List<EquipmentModel> listFromMap(List<dynamic> list) =>
      List<EquipmentModel>.from(list.map((x) => EquipmentModel.fromMap(x)));

  static List<EquipmentModel> listFromJson(String str) =>
      listFromMap(json.decode(str));
}