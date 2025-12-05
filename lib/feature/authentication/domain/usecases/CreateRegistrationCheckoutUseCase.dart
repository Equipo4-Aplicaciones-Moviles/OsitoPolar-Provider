import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/domain/entities/RegistrationCheckoutEntity.dart';
import 'package:osito_polar_app/feature/authentication/domain/repositories/AuthRepository.dart';
import 'package:equatable/equatable.dart';

class CreateRegistrationCheckoutUseCase {
  final AuthRepository repository;
  CreateRegistrationCheckoutUseCase(this.repository);

  // --- ¡MODIFICADO! ---
  // Ahora usa el nuevo 'CheckoutParams'
  Future<Either<Failure, RegistrationCheckoutEntity>> call(CheckoutParams params) async {
    return await repository.createRegistrationCheckout(
      planId: params.planId,
      userType: params.userType,
      successUrl: params.successUrl,
      cancelUrl: params.cancelUrl,
    );
  }
}

// --- ¡MODIFICADO! ---
// Este objeto 'Params' ahora solo tiene los 4 campos para la 1ra llamada
class CheckoutParams extends Equatable {
  final int planId;
  final String userType;
  final String successUrl;
  final String cancelUrl;

  const CheckoutParams({
    required this.planId,
    required this.userType,
    required this.successUrl,
    required this.cancelUrl,
  });

  @override
  List<Object?> get props => [planId, userType, successUrl, cancelUrl];
}