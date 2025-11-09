import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/domain/entities/AuthenticatedUserEntity.dart';

/// El "CONTRATO" (Interfaz) para el Repositorio de Autenticación.
abstract class AuthRepository {

  // --- ¡ASEGÚRATE DE QUE 'Future<...>' ESTÉ AQUÍ! ---
  Future<Either<Failure, AuthenticatedUserEntity>> signIn({
    required String username,
    required String password,
  });

  Future<Either<Failure, void>> signUp({
    required String username,
    required String password,
  });
}