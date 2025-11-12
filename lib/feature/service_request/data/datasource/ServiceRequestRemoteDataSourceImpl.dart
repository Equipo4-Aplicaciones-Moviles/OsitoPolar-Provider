import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:osito_polar_app/core/error/Exceptions.dart';
import 'package:osito_polar_app/feature/service_request/data/models/ServiceRequestModel.dart';
import 'ServiceRequestRemoteDataSource.dart';

class ServiceRequestRemoteDataSourceImpl implements ServiceRequestRemoteDataSource {
  final http.Client client;
  final SharedPreferences prefs;
  final String baseUrl;

  ServiceRequestRemoteDataSourceImpl({required this.client, required this.prefs})
      : baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8080';

  @override
  Future<List<ServiceRequestModel>> getServiceRequests() async {
    // Este método es para Owners, así que lo dejamos
    throw UnimplementedError("Este método no debe usarse por Providers");
  }

  // --- ¡¡MÉTODO ACTUALIZADO CON TRY...CATCH!! ---
  @override
  Future<List<ServiceRequestModel>> getAvailableServiceRequests() async {
    final token = prefs.getString('auth_token');
    if (token == null) {
      print("¡ERROR DE DATASOURCE! No se encontró 'auth_token'.");
      throw ServerException(message: 'Token no encontrado');
    }

    final url = Uri.parse('$baseUrl/api/v1/service-requests/marketplace');
    print('Llamando a la API del Marketplace: $url');

    try {
      // Intenta hacer la llamada a la API
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Si la llamada SÍ devuelve una respuesta (incluso un error 4xx o 5xx)
      if (response.statusCode == 200) {
        print("JSON CRUDO DEL MARKETPLACE (Éxito 200): ${response.body}");

        // Intenta leer el JSON
        final List<dynamic> requestsJson = jsonDecode(response.body);
        print("Respuesta del Marketplace: 200 OK. ${requestsJson.length} solicitudes encontradas.");

        // Intenta parsear el JSON
        return requestsJson.map((json) => ServiceRequestModel.fromMap(json)).toList();


      } else {
        // Si la API devuelve un error (401, 403, 404, 500)
        print("ERROR DE API (Marketplace): ${response.statusCode}");
        print("CUERPO DEL ERROR: ${response.body}");
        throw ServerException(message: 'Error al cargar el marketplace: ${response.statusCode}');
      }

    } catch (e) {
      // ¡¡ESTE ES EL BLOQUE MÁS IMPORTANTE!!
      // Si el código crashea (por red, parseo, o cualquier otra cosa),
      // lo atraparemos aquí.
      print("¡¡CRASH AL CARGAR EL MARKETPLACE!!: $e");
      throw ServerException(message: 'Crash en DataSource: ${e.toString()}');
    }
  }

  @override
  Future<void> acceptServiceRequest({
    required int serviceRequestId,
  }) async {
    // ... (Tu método acceptServiceRequest está bien por ahora)
    final token = prefs.getString('auth_token');
    if (token == null) throw ServerException(message: 'Token no encontrado');
    final url = Uri.parse('$baseUrl/api/v1/service-requests/$serviceRequestId/accept');
    print('Llamando a API (Accept Request): $url');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return;
    } else {
      print('Error al aceptar solicitud: ${response.statusCode} ${response.body}');
      throw ServerException(message: 'Error al aceptar solicitud: ${response.statusCode}');
    }
  }
}