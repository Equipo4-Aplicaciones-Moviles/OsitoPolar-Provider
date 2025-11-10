import 'dart:convert';

// Basado en el schema 'CreateEquipmentResource' de tu API (Swagger)
// ¡AHORA CON TODOS LOS CAMPOS REQUERIDOS!
class CreateEquipmentModel {
  // --- Campos de tu UI ---
  final String name;
  final String type;
  final String model;
  final String serialNumber;
  final int ownerId;

  // --- Campos Requeridos por el Error 400 ---
  final String code;
  final String notes;
  final String ownerType;
  final String locationName;
  final String manufacturer;
  final String ownershipType;
  final String locationAddress;
  final String technicalDetails;
  final String energyConsumptionUnit;

  // --- Campos Numéricos Opcionales (pero buenos de tener) ---
  final double cost;
  final double currentTemperature;
  final double setTemperature;
  final double optimalTemperatureMin;
  final double optimalTemperatureMax;
  final double locationLatitude;
  final double locationLongitude;
  final double energyConsumptionCurrent;
  final double energyConsumptionAverage;

  CreateEquipmentModel({
    required this.name,
    required this.type,
    required this.model,
    required this.serialNumber,
    required this.ownerId,
    required this.code,
    required this.notes,
    required this.ownerType,
    required this.locationName,
    required this.manufacturer,
    required this.ownershipType,
    required this.locationAddress,
    required this.technicalDetails,
    required this.energyConsumptionUnit,
    required this.cost,
    required this.currentTemperature,
    required this.setTemperature,
    required this.optimalTemperatureMin,
    required this.optimalTemperatureMax,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.energyConsumptionCurrent,
    required this.energyConsumptionAverage,
  });

  String toJson() => json.encode({
    // --- ¡AHORA USAMOS camelCase! ---
    // El error 400 te mostró PascalCase, pero el schema 'CreateEquipmentResource'
    // de tu API (en el JSON de Swagger) usa camelCase.
    // ¡Debemos seguir el schema!

    'name': name,
    'type': type,
    'model': model,
    'serialNumber': serialNumber,
    'ownerId': ownerId,
    'code': code,
    'notes': notes,
    'ownerType': ownerType,
    'locationName': locationName,
    'manufacturer': manufacturer,
    'ownershipType': ownershipType,
    'locationAddress': locationAddress,
    'technicalDetails': technicalDetails,
    'energyConsumptionUnit': energyConsumptionUnit,
    'cost': cost,
    'currentTemperature': currentTemperature,
    'setTemperature': setTemperature,
    'optimalTemperatureMin': optimalTemperatureMin,
    'optimalTemperatureMax': optimalTemperatureMax,
    'locationLatitude': locationLatitude,
    'locationLongitude': locationLongitude,
    'energyConsumptionCurrent': energyConsumptionCurrent,
    'energyConsumptionAverage': energyConsumptionAverage,
  });
}