import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:osito_polar_app/core/error/Exceptions.dart';
import 'package:osito_polar_app/feature/technician/data/models/TechnicianModel.dart';
import 'TechnicianRemoteDataSource.dart';

class TechnicianRemoteDataSourceImpl implements TechnicianRemoteDataSource {
  final http.Client client;
  final SharedPreferences prefs;
  final String baseUrl;

  TechnicianRemoteDataSourceImpl({required this.client, required this.prefs})
      : baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8080';

  @override
  Future<List<TechnicianModel>> getTechnicians() async {
    final token = prefs.getString('auth_token');
    if (token == null) throw ServerException(message: 'Token no encontrado');

    final url = Uri.parse('$baseUrl/api/v1/technicians');
    print('Llamando a API (GET Technicians): $url');

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return TechnicianModel.listFromJson(response.body);
    } else {
      print('Error al obtener técnicos: ${response.statusCode} ${response.body}');
      throw ServerException(message: 'Error al obtener técnicos: ${response.statusCode}');
    }
  }

  @override
  Future<TechnicianModel> createTechnician(
      {required Map<String, dynamic> technicianData}) async {
    final token = prefs.getString('auth_token');
    if (token == null) throw ServerException(message: 'Token no encontrado');

    final url = Uri.parse('$baseUrl/api/v1/technicians');
    print('Llamando a API (POST Technician): $url');

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(technicianData),
    );

    if (response.statusCode == 201) { // 201 Created
      return TechnicianModel.fromJson(response.body);
    } else {
      print('Error al crear técnico: ${response.statusCode} ${response.body}');
      throw ServerException(message: 'Error al crear técnico: ${response.statusCode}');
    }
  }

  @override
  Future<TechnicianModel> getTechnicianById(int technicianId) async {
    final token = prefs.getString('auth_token');
    if (token == null) throw ServerException(message: 'Token no encontrado');

    final url = Uri.parse('$baseUrl/api/v1/technicians/$technicianId');
    print('Llamando a API (GET Technician By ID): $url');

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Devuelve el técnico parseado
      return TechnicianModel.fromJson(response.body);
    } else if (response.statusCode == 404) {
      throw ServerException(message: 'Técnico no encontrado (404)');
    } else {
      print('Error al obtener técnico: ${response.statusCode} ${response.body}');
      throw ServerException(message: 'Error al obtener técnico: ${response.statusCode}');
    }
  }
}