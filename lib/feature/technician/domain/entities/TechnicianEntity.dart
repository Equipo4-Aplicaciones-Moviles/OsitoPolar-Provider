import 'package:equatable/equatable.dart';

class TechnicianEntity extends Equatable {
  final int id;
  final String name;
  final String? specialization;
  final String? phone;
  final String? email;
  final double averageRating; // La API dice que esto se calcula
  final String? availability;
  final int companyId; // A qué Provider (Compañía) pertenece

  const TechnicianEntity({
    required this.id,
    required this.name,
    this.specialization,
    this.phone,
    this.email,
    required this.averageRating,
    this.availability,
    required this.companyId,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    specialization,
    phone,
    email,
    averageRating,
    availability,
    companyId
  ];
}