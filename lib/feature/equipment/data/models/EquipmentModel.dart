import 'dart:convert';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
// Imports de Rental Info
import 'package:osito_polar_app/feature/equipment/data/models/RentalInfoModel.dart';

class EquipmentModel extends EquipmentEntity {

  const EquipmentModel({
    required super.id,
    required super.name,
    required super.type,
    required super.model,
    required super.serialNumber,
    required super.status,
    required super.currentTemperature,
    // Campos nuevos pasados al super
    super.setTemperature,
    super.isPoweredOn = false,

    required super.ownerId,
    required super.locationName,
    required super.code,
    required super.manufacturer,
    required super.energyConsumptionCurrent,
    required super.technicalDetails,
    required super.notes,
    required super.ownershipType,
    required super.cost,
    super.rentalInfo,
  });

  factory EquipmentModel.empty() {
    return const EquipmentModel(
      id: 0,
      name: '',
      type: '',
      model: '',
      serialNumber: '',
      status: 'inactive',
      currentTemperature: 0.0,
      setTemperature: 0.0,
      isPoweredOn: false,
      ownerId: 0,
      locationName: '',
      code: '',
      manufacturer: '',
      energyConsumptionCurrent: 0.0,
      technicalDetails: '',
      notes: '',
      ownershipType: 'Owned',
      cost: 0.0,
      rentalInfo: null,
    );
  }

  factory EquipmentModel.fromJson(String str) =>
      EquipmentModel.fromMap(json.decode(str));

  factory EquipmentModel.fromMap(Map<String, dynamic> json) {

    // Lógica para leer rentalInfo
    RentalInfoModel? rentalData;
    if (json['rentalInfo'] != null) {
      rentalData = RentalInfoModel.fromMap(json['rentalInfo']);
    }

    return EquipmentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Nombre no disponible',
      type: json['type'] ?? 'N/A',
      model: json['model'] ?? 'N/A',
      serialNumber: json['serialNumber'] ?? 'N/A',
      status: json['status'] ?? 'Desconocido',
      currentTemperature: (json['currentTemperature'] as num?)?.toDouble() ?? 0.0,

      // --- MAPEO DE CAMPOS NUEVOS ---
      setTemperature: (json['setTemperature'] as num?)?.toDouble(),
      isPoweredOn: json['isPoweredOn'] ?? false,

      ownerId: json['ownerId'] ?? 0,
      locationName: json['locationName'] ?? 'Ubicación desconocida',
      code: json['code'] ?? 'N/A',
      manufacturer: json['manufacturer'] ?? 'N/A',
      energyConsumptionCurrent: (json['energyConsumptionCurrent'] as num?)?.toDouble() ?? 0.0,
      technicalDetails: json['technicalDetails'] ?? 'N/A',
      notes: json['notes'] ?? 'N/A',
      ownershipType: json['ownershipType'] ?? 'Owned',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      rentalInfo: rentalData,
    );
  }

  EquipmentEntity toEntity() => this;

  static List<EquipmentModel> listFromMap(List<dynamic> list) =>
      List<EquipmentModel>.from(list.map((x) => EquipmentModel.fromMap(x)));

  static List<EquipmentModel> listFromJson(String str) =>
      listFromMap(json.decode(str));
}