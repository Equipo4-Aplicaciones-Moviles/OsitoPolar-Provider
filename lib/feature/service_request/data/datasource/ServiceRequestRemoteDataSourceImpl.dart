import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:osito_polar_app/feature/service_request/data/models/ServiceRequestModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ServiceRequestRemoteDataSource.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// (Reutilizamos la URL base)
const String kBaseUrl = 'http://localhost:8080';

class ServiceRequestRemoteDataSourceImpl implements ServiceRequestRemoteDataSource {
  final http.Client client;
  final SharedPreferences prefs;
  final String baseUrl;

  ServiceRequestRemoteDataSourceImpl({
    required this.client,
    required this.prefs,
  }): baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8080';

  @override
  Future<List<ServiceRequestModel>> getServiceRequests() async {
    // Esta es la URL incorrecta que causa el 403
    // final url = Uri.parse('$baseUrl/api/v1/service-requests');
    // ...
    throw UnimplementedError("Este método no debe usarse por Providers");
  }

  @override
  Future<List<ServiceRequestModel>> getAvailableServiceRequests() async {
    final token = prefs.getString('auth_token');
    if (token == null) throw Exception('Token not found');

    // ¡ESTA ES LA URL CORRECTA PARA EL MARKETPLACE!
    final url = Uri.parse('$baseUrl/api/v1/service-requests/marketplace');

    print('Llamando a la API del Marketplace: $url');

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> requestsJson = jsonDecode(response.body);

      // (Si la API devuelve {"requests": [...] } usa esta línea en su lugar)
      // final List<dynamic> requestsJson = jsonDecode(response.body)['requests'];

      print("Respuesta del Marketplace: 200 OK. ${requestsJson.length} solicitudes encontradas.");
      return requestsJson.map((json) => ServiceRequestModel.fromJson(json)).toList();
    } else {
      print('Error de API del Marketplace: ${response.statusCode} ${response.body}');
      throw Exception('Error al cargar el marketplace: ${response.statusCode}');
    }
  }


}