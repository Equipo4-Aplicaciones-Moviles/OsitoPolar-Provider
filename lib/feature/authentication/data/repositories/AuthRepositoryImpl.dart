import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/data/datasource/AuthRemoteDataSource.dart';
import 'package:osito_polar_app/feature/authentication/data/models/SignInRequestModel.dart';
import 'package:osito_polar_app/feature/authentication/domain/entities/AuthenticatedUserEntity.dart';
import 'package:osito_polar_app/feature/authentication/domain/repositories/AuthRepository.dart';

/// La "IMPLEMENTACIÓN" del contrato AuthRepository.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  // --- ¡ASEGÚRATE DE QUE 'Future<...>' y 'async' ESTÉN AQUÍ! ---
  Future<Either<Failure, AuthenticatedUserEntity>> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final requestModel =
      SignInRequestModel(username: username, password: password);

      final authenticatedUserModel = await remoteDataSource.signIn(requestModel);

      final userEntity = AuthenticatedUserEntity(
        id: authenticatedUserModel.id,
        username: authenticatedUserModel.username,
        token: authenticatedUserModel.token,
      );

      return Right(userEntity);

    } on Exception catch (e) {
      // TODO: Manejar excepciones específicas (401, 404, etc.)
      return Left(ServerFailure());
    }
  }
}