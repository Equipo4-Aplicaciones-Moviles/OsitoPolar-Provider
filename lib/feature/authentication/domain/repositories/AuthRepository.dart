import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/domain/entities/AuthenticatedUserEntity.dart';
import 'package:osito_polar_app/feature/authentication/domain/entities/RegistrationCheckoutEntity.dart';

import '../entities/RegistrationCredentialsEntity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthenticatedUserEntity>> signIn({
    required String username,
    required String password,
  });

  // --- ¡MODIFICADO! ---
  // Ahora solo toma los 4 campos que la API necesita
  Future<Either<Failure, RegistrationCheckoutEntity>> createRegistrationCheckout({
    required int planId,
    required String userType,
    required String successUrl,
    required String cancelUrl,
  });

  // --- ¡NUEVO MÉTODO! ---
  // Para la segunda llamada a la API
  Future<Either<Failure, RegistrationCredentialsEntity>> completeRegistration({
    required String sessionId,
    required Map<String, dynamic> registrationData,
  });

  Future<Either<Failure, AuthenticatedUserEntity>> verifyTwoFactor({
    required String username,
    required String code,
  });
}