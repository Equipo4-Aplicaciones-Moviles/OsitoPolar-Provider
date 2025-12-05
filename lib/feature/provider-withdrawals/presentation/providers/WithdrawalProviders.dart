import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import '../../data/repositories/WithdrawalRepository.dart';
import '../../domain/entities/WithdrawalBalanceEntity.dart';
 // Para los casos de uso

class WithdrawalProvider extends ChangeNotifier {
  final GetProviderBalanceUseCase getProviderBalanceUseCase;
  final RequestWithdrawalUseCase requestWithdrawalUseCase;

  WithdrawalProvider({
    required this.getProviderBalanceUseCase,
    required this.requestWithdrawalUseCase,
  });

  // Estado
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  WithdrawalBalanceEntity? _balanceData;
  double get currentBalance => _balanceData?.availableBalance ?? 0.00;
  String get currency => _balanceData?.currency ?? 'S/';

  // Cargar Balance
  Future<void> loadBalance() async {
    _isLoading = true;
    notifyListeners();

    final result = await getProviderBalanceUseCase(NoParams());

    result.fold(
          (failure) {
        _errorMessage = _mapFailure(failure);
      },
          (data) {
        _balanceData = data;
        _errorMessage = '';
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  // Solicitar Retiro
  Future<bool> requestWithdrawal(double amount, String method) async {
    _isLoading = true;
    notifyListeners();

    final result = await requestWithdrawalUseCase(amount, method);

    bool success = false;
    result.fold(
          (failure) {
        _errorMessage = _mapFailure(failure);
        success = false;
      },
          (_) {
        // Éxito: Restamos localmente para feedback inmediato y recargamos
        if (_balanceData != null) {
          _balanceData = WithdrawalBalanceEntity(
              availableBalance: _balanceData!.availableBalance - amount,
              currency: _balanceData!.currency
          );
        }
        success = true;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  String _mapFailure(Failure failure) {
    if (failure is ServerFailure) return failure.message ?? "Error del servidor";
    return "Error inesperado";
  }
}