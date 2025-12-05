import 'dart:convert';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentReadingEntity.dart';

class EquipmentReadingModel extends EquipmentReadingEntity {
  const EquipmentReadingModel({
    required super.timestamp,
    required super.value,
    required super.unit,
    required super.type,
  });

  factory EquipmentReadingModel.fromJson(String str) =>
      EquipmentReadingModel.fromMap(json.decode(str));

  factory EquipmentReadingModel.fromMap(Map<String, dynamic> json) {
    return EquipmentReadingModel(
      // Parseo de fecha (String ISO8601 -> DateTime)
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),

      // Parseo de valor numérico seguro
      value: (json['value'] as num?)?.toDouble() ?? 0.0,

      unit: json['unit'] ?? '',

      // Tipo: "temperature" o "energy"
      type: json['type'] ?? 'unknown',
    );
  }

  // Método para convertir lista de JSON a lista de Modelos
  static List<EquipmentReadingModel> listFromMap(List<dynamic> list) {
    return list.map((x) => EquipmentReadingModel.fromMap(x)).toList();
  }
}