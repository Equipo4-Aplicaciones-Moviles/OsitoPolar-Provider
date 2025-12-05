import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';
import 'package:osito_polar_app/feature/authentication/domain/entities/AuthenticatedUserEntity.dart';
import 'package:osito_polar_app/feature/authentication/domain/repositories/AuthRepository.dart';

class VerifyTwoFactorUseCase implements UseCase<AuthenticatedUserEntity, VerifyTwoFactorParams> {
  final AuthRepository repository;
  VerifyTwoFactorUseCase(this.repository);

  @override
  Future<Either<Failure, AuthenticatedUserEntity>> call(VerifyTwoFactorParams params) async {
    return await repository.verifyTwoFactor(username: params.username, code: params.code);
  }
}

class VerifyTwoFactorParams extends Equatable {
  final String username;
  final String code;
  const VerifyTwoFactorParams({required this.username, required this.code});
  @override
  List<Object?> get props => [username, code];
}