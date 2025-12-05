import 'dart:convert';

class EquipmentOperationModel {
  final double? temperature;
  final String? powerState; // "ON", "OFF"
  // Puedes agregar location u otros si los necesitas después

  EquipmentOperationModel({
    this.temperature,
    this.powerState,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (temperature != null) data['temperature'] = temperature;
    if (powerState != null) data['powerState'] = powerState;
    return data;
  }
}