import 'dart:convert';
import 'package:osito_polar_app/feature/technician/domain/entities/TechnicianEntity.dart';

// Este modelo hereda de la Entidad y añade los métodos from/to JSON
class TechnicianModel extends TechnicianEntity {

  const TechnicianModel({
    required super.id,
    required super.name,
    super.specialization,
    super.phone,
    super.email,
    required super.averageRating,
    super.availability,
    required super.companyId,
  });

  factory TechnicianModel.fromJson(String str) =>
      TechnicianModel.fromMap(json.decode(str));

  // Convierte un Map (de JSON) a nuestro modelo
  factory TechnicianModel.fromMap(Map<String, dynamic> json) => TechnicianModel(
    id: json['id'],
    name: json['name'],
    specialization: json['specialization'],
    phone: json['phone'],
    email: json['email'],
    averageRating: json['averageRating']?.toDouble() ?? 0.0,
    availability: json['availability'],
    companyId: json['companyId'],
  );

  // Convierte nuestro Modelo (Datos) a una Entidad (Dominio)
  // (En este caso, como heredamos, la instancia actual ES una Entidad)
  TechnicianEntity toEntity() => this;

  // Helper para parsear una lista de JSON
  static List<TechnicianModel> listFromJson(String str) =>
      List<TechnicianModel>.from(json.decode(str).map((x) => TechnicianModel.fromMap(x)));
}