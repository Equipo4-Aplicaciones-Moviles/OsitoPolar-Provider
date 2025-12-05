import 'package:dartz/dartz.dart';

// --- Tus importaciones con 'feature' (singular) y 'PascalCase.dart' ---
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/domain/entities/AuthenticatedUserEntity.dart';
import 'package:osito_polar_app/feature/authentication/domain/repositories/AuthRepository.dart';

/// El Caso de Uso (UseCase) para el "Sign In".
class SignInUseCase {
  final AuthRepository repository;

  // Depende del "contrato" (AuthRepository), no de la implementación.
  SignInUseCase(this.repository);

  /// El método `call` permite que el UseCase sea llamado como una función.
  //
  // --- AÑADIMOS 'async' y 'await' ---
  Future<Either<Failure, AuthenticatedUserEntity>> call({
    required String username,
    required String password,
  }) async { // <-- async
    // Esta es la línea que llama al repositorio y espera la respuesta
    return await repository.signIn(username: username, password: password); // <-- await
  }
}