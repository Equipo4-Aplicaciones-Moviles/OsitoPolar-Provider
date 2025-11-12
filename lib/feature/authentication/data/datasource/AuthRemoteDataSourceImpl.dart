import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// (Imports de tus modelos)
import 'package:osito_polar_app/feature/authentication/data/models/SignInRequestModel.dart';
import 'package:osito_polar_app/feature/authentication/data/models/AuthenticatedUserModel.dart';
import 'package:osito_polar_app/feature/authentication/data/models/RegistrationCheckoutModel.dart';
import 'package:osito_polar_app/feature/authentication/data/datasource/AuthRemoteDataSource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  AuthRemoteDataSourceImpl({required this.client})
      : baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8080';

  @override
  Future<AuthenticatedUserModel> signIn(SignInRequestModel request) async {
    // ... (Tu código de signIn - sin cambios)
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

  @override
  Future<RegistrationCheckoutModel> createRegistrationCheckout({
    required int planId,
    required String userType,
    required String successUrl,
    required String cancelUrl,
  }) async {
    // ¡La URL corregida que encontramos!
    final uri = Uri.parse('$baseUrl/api/v1/authentication/create-registration-checkout');
    print('Llamando a la API (Paso 1): $uri');

    try {
      final response = await client.post(
        uri,
        headers: { 'Content-Type': 'application/json' },
        // --- ¡MODIFICADO! ---
        // Enviamos solo los 4 campos que la API espera
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

  // --- ¡NUEVO MÉTODO! ---
  @override
  Future<void> completeRegistration({
    required String sessionId,
    required Map<String, dynamic> registrationData,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/authentication/complete-registration');
    print('Llamando a la API (Paso 2): $uri');

    // Prepara el body: El Map ya contiene todos los datos del formulario,
    // solo nos aseguramos de que también tenga el sessionId.
    final body = {
      ...registrationData, // (username, email, companyName, etc.)
      'sessionId': sessionId,
    };

    try {
      final response = await client.post(
        uri,
        headers: { 'Content-Type': 'application/json' },
        body: jsonEncode(body),
      );

      // La API devuelve 200 OK si el registro es exitoso
      if (response.statusCode == 200) {
        print("Respuesta de Registro (Paso 2): ${response.body}");
        print("¡Registro completado exitosamente!");
        return; // Éxito (void)
      } else {
        print('Error API (Paso 2): ${response.body}');
        throw Exception('Error al completar el registro: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de red (Paso 2): $e');
      throw Exception('No se pudo conectar al servidor.');
    }
  }
}