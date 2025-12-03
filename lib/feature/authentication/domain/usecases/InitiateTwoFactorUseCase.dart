import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/data/models/TwoFactorSecretModel.dart';
import 'package:osito_polar_app/feature/authentication/domain/repositories/AuthRepository.dart';

class InitiateTwoFactorUseCase {
  final AuthRepository repository;

  InitiateTwoFactorUseCase(this.repository);

  Future<Either<Failure, TwoFactorSecretModel>> call(String username) {
    return repository.initiateTwoFactor(username);
  }
}