import 'package:equatable/equatable.dart';

/// La Entidad PURA de una Solicitud de Servicio (Mantenimiento).
/// Pertenece a la capa de Domain y es lo que la UI usará.
class ServiceRequestEntity extends Equatable {
  final int id;
  final String orderNumber;
  final String title;
  final String status;
  final String priority;
  final String serviceType;
  final int equipmentId;

  // (Añadimos 'clientId' y 'companyId' aunque tu UI de
  //  mantenimiento no los muestra, son útiles)
  final int? clientId;
  final int? companyId;


  const ServiceRequestEntity({
    required this.id,
    required this.orderNumber,
    required this.title,
    required this.status,
    required this.priority,
    required this.serviceType,
    required this.equipmentId,
    this.clientId,
    this.companyId,
  });

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    title,
    status,
    priority,
    serviceType,
    equipmentId,
    clientId,
    companyId,
  ];
}