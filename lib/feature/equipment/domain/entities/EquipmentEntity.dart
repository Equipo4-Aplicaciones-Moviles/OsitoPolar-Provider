import 'package:equatable/equatable.dart';

/// La Entidad PURA de un Equipo.
/// Pertenece a la capa de Domain y es lo que la UI usará.
class EquipmentEntity extends Equatable {
  final int id;
  final String name;
  final String type;
  final String model;
  final String serialNumber;
  final String status;
  final double currentTemperature;
  final int ownerId;

  const EquipmentEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.model,
    required this.serialNumber,
    required this.status,
    required this.currentTemperature,
    required this.ownerId,
  });

  @override
  List<Object> get props => [
    id,
    name,
    type,
    model,
    serialNumber,
    status,
    currentTemperature,
    ownerId
  ];
}