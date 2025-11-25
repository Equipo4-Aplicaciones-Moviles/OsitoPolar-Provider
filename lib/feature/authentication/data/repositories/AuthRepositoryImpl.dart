import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/data/datasource/AuthRemoteDataSource.dart';
import 'package:osito_polar_app/feature/authentication/data/models/SignInRequestModel.dart';
import 'package:osito_polar_app/feature/authentication/domain/entities/AuthenticatedUserEntity.dart';
import 'package:osito_polar_app/feature/authentication/domain/repositories/AuthRepository.dart';
// --- ¡NUEVO IMPORT! ---
import 'package:osito_polar_app/feature/authentication/domain/entities/RegistrationCheckoutEntity.dart';

import '../../domain/entities/RegistrationCredentialsEntity.dart';


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
  Future<Either<Failure, RegistrationCredentialsEntity>> completeRegistration({
    required String sessionId,
    required Map<String, dynamic> registrationData,
  }) async {
    try {
      // 1. Llama al DataSource y recibe el MODELO
      final credentialsModel = await remoteDataSource.completeRegistration(
        sessionId: sessionId,
        registrationData: registrationData,
      );

      // 2. Convierte el Modelo a ENTIDAD y devuélvelo
      return Right(credentialsModel.toEntity());

    } on Exception catch (e) {
      // (Manejo de errores simple, puedes mejorarlo con ServerException)
      return Left(ServerFailure(message: e.toString()));
    }
  }
}