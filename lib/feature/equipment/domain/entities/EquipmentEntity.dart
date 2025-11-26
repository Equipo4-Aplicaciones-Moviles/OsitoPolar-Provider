import 'package:equatable/equatable.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/RentalInfoEntity.dart';
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
  final String locationName;

  // --- ¡CAMPOS AÑADIDOS! ---
  final String code;
  final String manufacturer;
  final double energyConsumptionCurrent;
  final String technicalDetails;
  final String notes;
  // (Campos 'falsos' que la UI necesita pero la API no da)
  final String voltage = "220 V"; // (Valor Falso)
  final String refrigerant = "R-134a"; // (Valor Falso)
  final String ownershipType;


  final double cost;
  final RentalInfoEntity? rentalInfo;


  const EquipmentEntity({
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

    required this.cost,
    this.rentalInfo,

  });

  bool get isPublishedForRent {
    return rentalInfo != null ||
        ownershipType == 'Rented' ||
        ownershipType == 'RenterProvider';
  }

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    model,
    serialNumber,
    status,
    currentTemperature,
    ownerId,
    locationName,
    code,
    manufacturer,
    energyConsumptionCurrent,
    technicalDetails,
    notes,
    ownershipType,
    rentalInfo,
    cost

  ];
}