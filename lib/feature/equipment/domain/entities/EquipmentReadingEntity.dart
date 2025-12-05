import 'package:equatable/equatable.dart';

class EquipmentReadingEntity extends Equatable {
  final DateTime timestamp;
  final double value;
  final String unit;
  final String type; // "temperature" o "energy"

  const EquipmentReadingEntity({
    required this.timestamp,
    required this.value,
    required this.unit,
    required this.type,
  });

  @override
  List<Object?> get props => [timestamp, value, unit, type];
}