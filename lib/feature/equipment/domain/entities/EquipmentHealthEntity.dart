import 'package:equatable/equatable.dart';

class EquipmentHealthEntity extends Equatable {
  // Puntuación General (Score)
  final double overallScore; // Ej: 92.5
  final String status;       // Ej: "Optimal", "Warning", "Critical"
  final String recommendation; // Ej: "Revisar aislamiento de puerta."

  // Métricas de Estabilidad
  final double temperatureVariance; // Ej: 1.5 (Qué tanto varía la temperatura)
  final double recentTrend;         // Ej: 0.2 (Si la temperatura subió o bajó recientemente)

  // Datos extra para Anomalías (si se combinan)
  final List<String> detectedAnomalies; // Ej: ["Door Open", "High Cycle Count"]

  const EquipmentHealthEntity({
    required this.overallScore,
    required this.status,
    required this.recommendation,
    required this.temperatureVariance,
    required this.recentTrend,
    this.detectedAnomalies = const [],
  });

  @override
  List<Object> get props => [
    overallScore,
    status,
    recommendation,
    temperatureVariance,
    recentTrend,
    detectedAnomalies,
  ];
}