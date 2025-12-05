import 'package:equatable/equatable.dart';

class ServiceRequestEntity extends Equatable {
  final int id;
  final String title;
  final int? clientId;
  final String status;

  // --- CAMPOS NUEVOS PARA LA UI ---
  final String urgency;        // "critical", "high", "medium", "low"
  final String? serviceType;   // "Mantenimiento", "Reparación", etc.
  final DateTime? scheduledDate; // Para saber si es "Hoy"
  final String? timeSlot;      // "14:00 - 16:00"
  final String? serviceAddress; // "Av. Larco 123"
  final String? description;   // Detalles extra

  const ServiceRequestEntity({
    required this.id,
    required this.title,
    this.clientId,
    required this.status,
    // --- Requerimos o permitimos nulos según lógica ---
    required this.urgency,
    this.serviceType,
    this.scheduledDate,
    this.timeSlot,
    this.serviceAddress,
    this.description,
  });

  @override
  List<Object?> get props => [
    id, title, clientId, status,
    urgency, serviceType, scheduledDate, timeSlot, serviceAddress, description
  ];
}