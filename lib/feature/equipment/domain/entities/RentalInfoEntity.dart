import 'package:equatable/equatable.dart';

class RentalInfoEntity extends Equatable {
  final double monthlyFee;
  final DateTime startDate; // En la API es 'availableFrom'
  final DateTime endDate;   // En la API es 'availableUntil'

  const RentalInfoEntity({
    required this.monthlyFee,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [monthlyFee, startDate, endDate];
}