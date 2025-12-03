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

  // --- CAMPOS NUEVOS (Para control en UI) ---
  final double? setTemperature; // Temperatura deseada (Termostato)
  final bool isPoweredOn;       // Estado de encendido

  final int ownerId;
  final String locationName;

  // --- OTROS CAMPOS ---
  final String code;
  final String manufacturer;
  final double energyConsumptionCurrent;
  final String technicalDetails;
  final String notes;

  // (Campos 'falsos' que la UI necesita pero la API no da)
  final String voltage = "220 V";
  final String refrigerant = "R-134a";
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

    // Campos opcionales nuevos
    this.setTemperature,
    this.isPoweredOn = false,

    required this.ownerId,
    required this.locationName,
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

  // --- ¡AQUÍ ESTÁ EL COPYWITH QUE NECESITABAS! ---
  EquipmentEntity copyWith({
    int? id,
    String? name,
    String? type,
    String? model,
    String? serialNumber,
    String? status,
    double? currentTemperature,
    double? setTemperature,
    bool? isPoweredOn,
    int? ownerId,
    String? locationName,
    String? code,
    String? manufacturer,
    double? energyConsumptionCurrent,
    String? technicalDetails,
    String? notes,
    String? ownershipType,
    double? cost,
    RentalInfoEntity? rentalInfo,
  }) {
    return EquipmentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      model: model ?? this.model,
      serialNumber: serialNumber ?? this.serialNumber,
      status: status ?? this.status,
      currentTemperature: currentTemperature ?? this.currentTemperature,
      setTemperature: setTemperature ?? this.setTemperature,
      isPoweredOn: isPoweredOn ?? this.isPoweredOn,
      ownerId: ownerId ?? this.ownerId,
      locationName: locationName ?? this.locationName,
      code: code ?? this.code,
      manufacturer: manufacturer ?? this.manufacturer,
      energyConsumptionCurrent: energyConsumptionCurrent ?? this.energyConsumptionCurrent,
      technicalDetails: technicalDetails ?? this.technicalDetails,
      notes: notes ?? this.notes,
      ownershipType: ownershipType ?? this.ownershipType,
      cost: cost ?? this.cost,
      rentalInfo: rentalInfo ?? this.rentalInfo,
    );
  }

  @override
  List<Object?> get props => [
    id, name, type, model, serialNumber, status, currentTemperature,
    setTemperature, isPoweredOn, // No olvides agregarlos aquí
    ownerId, locationName, code, manufacturer, energyConsumptionCurrent,
    technicalDetails, notes, ownershipType, rentalInfo, cost
  ];
}