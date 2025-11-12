import 'package:equatable/equatable.dart';

class ServiceRequestEntity extends Equatable {
  final int id;
  final String title;
  final int? clientId; // El JSON tiene 'clientId: 3'
  final String status;   // El JSON tiene 'status: "Pending"'

  const ServiceRequestEntity({
    required this.id,
    required this.title,
    this.clientId,
    required this.status,
  });

  @override
  List<Object?> get props => [id, title, clientId, status];
}