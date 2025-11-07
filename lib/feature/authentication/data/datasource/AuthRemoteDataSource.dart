// --- TUS NOMBRES DE ARCHIVO 'PascalCase' ---
import 'package:osito_polar_app/feature/authentication/data/models/SignInRequestModel.dart';
import 'package:osito_polar_app/feature/authentication/data/models/AuthenticatedUserModel.dart';

// --- ¡ESTE ES EL ARCHIVO CORREGIDO! ---
//
// Esta es la "Interfaz" (el contrato).
// Hemos BORRADO la clase 'AuthRemoteDataSourceImpl' de este archivo
// porque ya vive en su propio archivo ('AuthRemoteDataSourceImpl.dart').

abstract class AuthRemoteDataSource {
  /// Llama al endpoint POST /api/v1/authentication/sign-in
  ///
  /// Arroja una [Exception] si el código de estado no es 200.
  Future<AuthenticatedUserModel> signIn(SignInRequestModel request);

// TODO: Añadir un método signUp aquí
}