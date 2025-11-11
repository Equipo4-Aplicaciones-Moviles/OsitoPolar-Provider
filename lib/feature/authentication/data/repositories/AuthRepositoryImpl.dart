import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/data/datasource/AuthRemoteDataSource.dart';
import 'package:osito_polar_app/feature/authentication/data/models/SignInRequestModel.dart';
import 'package:osito_polar_app/feature/authentication/domain/entities/AuthenticatedUserEntity.dart';
import 'package:osito_polar_app/feature/authentication/domain/repositories/AuthRepository.dart';
// --- ¡NUEVO IMPORT! ---
import 'package:osito_polar_app/feature/authentication/domain/entities/RegistrationCheckoutEntity.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthenticatedUserEntity>> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final requestModel = SignInRequestModel(username: username, password: password);
      final authenticatedUserModel = await remoteDataSource.signIn(requestModel);

      // ¡Usamos el .toEntity() actualizado!
      final userEntity = authenticatedUserModel.toEntity();

      return Right(userEntity);

    } on Exception catch (e) {
      // TODO: Manejar excepciones específicas
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, RegistrationCheckoutEntity>> createRegistrationCheckout({
    required int planId,
    required String userType,
    required String successUrl,
    required String cancelUrl,
  }) async {
    try {
      final checkoutModel = await remoteDataSource.createRegistrationCheckout(
        planId: planId,
        userType: userType,
        successUrl: successUrl,
        cancelUrl: cancelUrl,
      );
      return Right(checkoutModel.toEntity());
    } on Exception catch (e) {
      return Left(ServerFailure());
    }
  }

  // --- ¡NUEVO MÉTODO! ---
  @override
  Future<Either<Failure, void>> completeRegistration({
    required String sessionId,
    required Map<String, dynamic> registrationData,
  }) async {
    try {
      // El DataSource no devuelve nada (void)
      await remoteDataSource.completeRegistration(
        sessionId: sessionId,
        registrationData: registrationData,
      );
      return const Right(null); // (Right(null) significa Éxito/void)
    } on Exception catch (e) {
      return Left(ServerFailure());
    }
  }
}