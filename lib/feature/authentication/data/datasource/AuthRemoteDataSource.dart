import 'package:osito_polar_app/feature/authentication/data/models/SignInRequestModel.dart';
import 'package:osito_polar_app/feature/authentication/data/models/AuthenticatedUserModel.dart';
import 'package:osito_polar_app/feature/authentication/data/models/RegistrationCheckoutModel.dart';

abstract class AuthRemoteDataSource {
  Future<AuthenticatedUserModel> signIn(SignInRequestModel request);

  // --- ¡MODIFICADO! ---
  // Ahora solo toma los 4 campos
  Future<RegistrationCheckoutModel> createRegistrationCheckout({
    required int planId,
    required String userType,
    required String successUrl,
    required String cancelUrl,
  });

  // --- ¡NUEVO MÉTODO! ---
  Future<void> completeRegistration({
    required String sessionId,
    required Map<String, dynamic> registrationData,
  });
}