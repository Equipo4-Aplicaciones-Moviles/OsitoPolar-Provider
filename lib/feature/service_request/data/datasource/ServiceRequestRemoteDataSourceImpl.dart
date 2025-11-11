import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:osito_polar_app/feature/service_request/data/models/ServiceRequestModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ServiceRequestRemoteDataSource.dart';

// (Reutilizamos la URL base)
const String kBaseUrl = 'http://localhost:5128';

class ServiceRequestRemoteDataSourceImpl implements ServiceRequestRemoteDataSource {
  final http.Client client;
  final SharedPreferences prefs;

  ServiceRequestRemoteDataSourceImpl({
    required this.client,
    required this.prefs,
  });

  @override
  Future<List<ServiceRequestModel>> getServiceRequests() async {
    final uri = Uri.parse('$kBaseUrl/api/v1/service-requests');
    print('Llamando a API: $uri');

    // Esta llamada necesita un Token
    final token = prefs.getString('auth_token');
    if (token == null) {
      print('¡Error! No se encontró token. El usuario no está logueado.');
      throw Exception('Token no encontrado');
    }

    final response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Respuesta de ServiceRequests: ${response.statusCode}');

    if (response.statusCode == 200) {
      // La API devolvió una lista de solicitudes
      return ServiceRequestModel.listFromJson(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Token inválido o expirado (401)');
    } else {
      throw Exception('Error al obtener las solicitudes de servicio: ${response.statusCode}');
    }
  }
}