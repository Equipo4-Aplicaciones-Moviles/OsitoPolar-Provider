import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/domain/repositories/AuthRepository.dart';

/// El Caso de Uso (UseCase) para el "Sign Up" (Registro).
class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  /// Llama al método signUp del repositorio.
  /// Devuelve void (nada) si es exitoso.
  Future<Either<Failure, void>> call({
    required String username,
    required String password,
  }) async {
    return await repository.signUp(username: username, password: password);
  }
}