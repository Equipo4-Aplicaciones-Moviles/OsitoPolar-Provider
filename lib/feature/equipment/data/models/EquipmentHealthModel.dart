import 'dart:convert';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentHealthEntity.dart';

class EquipmentHealthModel extends EquipmentHealthEntity {
  const EquipmentHealthModel({
    required super.overallScore,
    required super.status,
    required super.recommendation,
    required super.temperatureVariance,
    required super.recentTrend,
    super.detectedAnomalies,
  });

  factory EquipmentHealthModel.fromJson(String str) =>
      EquipmentHealthModel.fromMap(json.decode(str));

  factory EquipmentHealthModel.fromMap(Map<String, dynamic> json) {
    // Nota: Estos nombres de campo son suposiciones basadas en el objetivo del endpoint.
    // Ajústalos a los nombres reales de las propiedades JSON que te devuelva la API.
    return EquipmentHealthModel(
      overallScore: (json['overallScore'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'Optimal',
      recommendation: json['recommendation'] ?? 'No se detectaron problemas.',
      temperatureVariance: (json['temperatureVariance'] as num?)?.toDouble() ?? 0.0,
      recentTrend: (json['recentTrend'] as num?)?.toDouble() ?? 0.0,
      detectedAnomalies: (json['anomalies'] as List<dynamic>?)?.map((x) => x.toString()).toList() ?? [],
    );
  }
}