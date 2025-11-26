import 'package:osito_polar_app/feature/equipment/domain/entities/RentalInfoEntity.dart';

class RentalInfoModel extends RentalInfoEntity {

  const RentalInfoModel({
    required super.monthlyFee,
    required super.startDate,
    required super.endDate,
  });

  factory RentalInfoModel.fromMap(Map<String, dynamic> json) {
    return RentalInfoModel(
      // Convertimos a double asegurándonos de que no falle si viene int
      monthlyFee: (json['monthlyFee'] as num).toDouble(),
      // La API suele devolver fechas en formato ISO String
      startDate: DateTime.parse(json['availableFrom']),
      endDate: DateTime.parse(json['availableUntil']),
    );
  }

  // Convierte este modelo de datos en una entidad de dominio limpia
  RentalInfoEntity toEntity() => this;
}