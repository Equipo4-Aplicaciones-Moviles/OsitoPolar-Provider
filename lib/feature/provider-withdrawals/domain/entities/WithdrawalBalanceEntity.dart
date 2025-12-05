import 'package:equatable/equatable.dart';

class WithdrawalBalanceEntity extends Equatable {
  final double availableBalance;
  final String currency; // "PEN", "USD", etc.

  const WithdrawalBalanceEntity({
    required this.availableBalance,
    required this.currency,
  });

  @override
  List<Object?> get props => [availableBalance, currency];
}