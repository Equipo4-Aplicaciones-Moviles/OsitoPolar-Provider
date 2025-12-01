import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:osito_polar_app/feature/authentication/data/models/SignInRequestModel.dart';
import 'package:osito_polar_app/feature/authentication/data/models/AuthenticatedUserModel.dart';
import 'package:osito_polar_app/feature/authentication/data/models/RegistrationCheckoutModel.dart';
import 'package:osito_polar_app/feature/authentication/data/datasource/AuthRemoteDataSource.dart';
// --- ¡AÑADE ESTE IMPORT! ---
import 'package:osito_polar_app/feature/authentication/data/models/RegistrationCredentialsModel.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  AuthRemoteDataSourceImpl({required this.client})
      : baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8080';

  // (signIn - sin cambios)
  @override
  Future<AuthenticatedUserModel> signIn(SignInRequestModel request) async {
    final uri = Uri.parse('$baseUrl/api/v1/authentication/sign-in');
    print('Llamando a la API: $uri');
    try {
      final response = await client.post(
        uri,
        headers: { 'Content-Type': 'application/json' },
        body: request.toJson(),
      );
      if (response.statusCode == 200) {
        return AuthenticatedUserModel.fromJson(response.body);
      } else {
        throw Exception('Error al iniciar sesión: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('No se pudo conectar al servidor.');
    }
  }

  // (createRegistrationCheckout - sin cambios)
  @override
  Future<RegistrationCheckoutModel> createRegistrationCheckout({
    required int planId,
    required String userType,
    required String successUrl,
    required String cancelUrl,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/authentication/create-registration-checkout');
    print('Llamando a la API (Paso 1): $uri');

    try {
      final response = await client.post(
        uri,
        headers: { 'Content-Type': 'application/json' },
        body: jsonEncode({
          "planId": planId,
          "userType": userType,
          "successUrl": successUrl,
          "cancelUrl": cancelUrl,
        }),
      );

      if (response.statusCode == 200) {
        return RegistrationCheckoutModel.fromJson(response.body);
      } else {
        print('Error API (Paso 1): ${response.body}');
        throw Exception('Error al crear checkout: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de red (Paso 1): $e');
      throw Exception('No se pudo conectar al servidor.');
    }
  }

  // --- ¡MÉTODO CORREGIDO! ---
  @override
  Future<RegistrationCredentialsModel> completeRegistration({ // <-- Cambiado de void a Model
    required String sessionId,
    required Map<String, dynamic> registrationData,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/authentication/complete-registration');
    print('Llamando a la API (Paso 2): $uri');

    final body = {
      ...registrationData,
      'sessionId': sessionId,
    };

    try {
      final response = await client.post(
        uri,
        headers: { 'Content-Type': 'application/json' },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("Respuesta de Registro (Paso 2): ${response.body}");
        // --- ¡CAMBIO! Parseamos y devolvemos el modelo ---
        return RegistrationCredentialsModel.fromJson(response.body);
      } else {
        print('Error API (Paso 2): ${response.body}');
        throw Exception('Error al completar el registro: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de red (Paso 2): $e');
      throw Exception('No se pudo conectar al servidor.');
    }
  }
  @override
  Future<AuthenticatedUserModel> verifyTwoFactor({
    required String username,
    required String code,
  }) async {
    // Llama a: POST /api/v1/authentication/verify-2fa
    final uri = Uri.parse('$baseUrl/api/v1/authentication/verify-2fa');
    print('Llamando a API (Verify 2FA): $uri');

    try {
      final response = await client.post(
        uri,
        headers: { 'Content-Type': 'application/json' },
        body: jsonEncode({
          'username': username,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        return AuthenticatedUserModel.fromJson(response.body);
      } else {
        throw Exception('Código incorrecto o error de servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión en 2FA.');
    }
  }
}