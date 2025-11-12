import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// --- Imports de tu app ---
import 'package:osito_polar_app/core/error/Exceptions.dart'; // ¡Importante para ServerException!
import 'package:osito_polar_app/feature/equipment/data/models/EquipmentModel.dart';
import 'package:osito_polar_app/feature/equipment/data/models/CreateEquipmentModel.dart';
import 'EquipmentRemoteDataSource.dart';

class EquipmentRemoteDataSourceImpl implements EquipmentRemoteDataSource {
  final http.Client client;
  final SharedPreferences prefs;
  final String baseUrl; // <- Usaremos esta variable para todas las llamadas

  EquipmentRemoteDataSourceImpl({required this.client, required this.prefs})
  // Carga la URL base desde el archivo .env
      : baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8080';

  @override
  Future<List<EquipmentModel>> getEquipments() async {
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw ServerException(message: 'Token no encontrado');
    }

    // ¡Corregido! Usa la variable 'baseUrl' de la clase
    final url = Uri.parse('$baseUrl/api/v1/equipments');

    print('Llamando a API: $url');

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Respuesta de Equipos: ${response.statusCode}');

    if (response.statusCode == 200) {
      return EquipmentModel.listFromJson(response.body);
    } else if (response.statusCode == 401) {
      throw ServerException(message: 'Token inválido o expirado (401)');
    } else {
      throw ServerException(
          message: 'Error al obtener equipos: ${response.statusCode}');
    }
  }

  @override
  Future<EquipmentModel> createEquipment(CreateEquipmentModel equipment) async {
    // ¡Corregido! Usa la variable 'baseUrl' de la clase
    final uri = Uri.parse('$baseUrl/api/v1/equipments');
    print('Llamando a API (POST): $uri');

    final token = prefs.getString('auth_token');
    if (token == null) {
      throw ServerException(message: 'Token no encontrado');
    }

    try {
      final response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: equipment.toJson(),
      );

      print('Respuesta de Crear Equipo: ${response.statusCode}');

      if (response.statusCode == 201) {
        return EquipmentModel.fromJson(response.body);
      } else {
        print('Error de API: ${response.body}');
        throw ServerException(
            message: 'Error al crear el equipo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de red: $e');
      throw ServerException(message: 'No se pudo conectar al servidor.');
    }
  }

  @override
  Future<EquipmentModel> getEquipmentById(int equipmentId) async {
    // ¡Corregido! Usa la variable 'baseUrl' de la clase
    final uri = Uri.parse('$baseUrl/api/v1/equipments/$equipmentId');
    print('Llamando a API: $uri');

    final token = prefs.getString('auth_token');
    if (token == null) {
      throw ServerException(message: 'Token no encontrado');
    }

    try {
      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Respuesta de Get Equipo Por ID: ${response.statusCode}');

      if (response.statusCode == 200) {
        return EquipmentModel.fromJson(response.body);
      } else if (response.statusCode == 404) {
        throw ServerException(message: 'Equipo no encontrado (404)');
      } else {
        print('Error de API: ${response.body}');
        throw ServerException(
            message: 'Error al obtener el equipo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de red: $e');
      throw ServerException(message: 'No se pudo conectar al servidor.');
    }
  }

  @override
  Future<void> deleteEquipment(int equipmentId) async {
    // ¡Corregido! Usa la variable 'baseUrl' de la clase
    final uri = Uri.parse('$baseUrl/api/v1/equipments/$equipmentId');
    print('Llamando a API (DELETE): $uri');

    final token = prefs.getString('auth_token');
    if (token == null) {
      throw ServerException(message: 'Token no encontrado');
    }

    try {
      final response = await client.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Respuesta de Delete Equipo: ${response.statusCode}');

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 404) {
        throw ServerException(message: 'Equipo no encontrado (404)');
      } else {
        print('Error de API: ${response.body}');
        throw ServerException(
            message: 'Error al borrar el equipo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de red: $e');
      throw ServerException(message: 'No se pudo conectar al servidor.');
    }
  }

  @override
  Future<EquipmentModel> updateEquipment(int equipmentId,
      CreateEquipmentModel equipment) async {
    // ¡Corregido! Usa la variable 'baseUrl' de la clase
    final uri = Uri.parse('$baseUrl/api/v1/equipments/$equipmentId');
    print('Llamando a API (PUT): $uri');

    final token = prefs.getString('auth_token');
    if (token == null) {
      throw ServerException(message: 'Token no encontrado');
    }

    try {
      final response = await client.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: equipment.toJson(),
      );

      print('Respuesta de Publish (${response.statusCode}): ${response.body}');

      if (response.statusCode == 200) {
        return EquipmentModel.fromJson(response.body);
      } else if (response.statusCode == 404) {
        throw ServerException(message: 'Equipo no encontrado (404)');
      } else if (response.statusCode == 400) {
        print('Error de API (400): ${response.body}');
        throw ServerException(
            message: 'Error de validación: ${response.statusCode}');
      } else {
        print('Error de API: ${response.body}');
        throw ServerException(
            message: 'Error al actualizar el equipo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de red: $e');
      throw ServerException(message: 'No se pudo conectar al servidor.');
    }
  }

  // --- ¡NUEVO MÉTODO AÑADIDO! ---
  @override
  Future<EquipmentModel> publishEquipment({
    required int equipmentId,
    required double monthlyFee,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final token = prefs.getString('auth_token');
    if (token == null) throw ServerException(message: 'Token not found');

    // Esta es la URL correcta para Publicar (PUT)
    final url = Uri.parse('$baseUrl/api/v1/equipments/$equipmentId/rental');
    print('Llamando a API (Publish): $url');

    // Preparamos el Body que la API espera (Schema: PublishForRentResource)
    final body = jsonEncode({
      'monthlyFee': monthlyFee,
      'startDate': startDate.toIso8601String(), // Formato estándar de fecha
      'endDate': endDate.toIso8601String(),
    });


    try {
      final response = await client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      print('Respuesta de Publish (${response.statusCode}): ${response.body}');

      if (response.statusCode == 200) {
        return EquipmentModel.fromJson(response.body);
      } else if (response.statusCode == 400) {
        print('Error de validación: ${response.body}');
        throw ServerException(
            message: 'Error al publicar (400): ${response.body}');
      } else {
        print('Error de API: ${response.body}');
        throw ServerException(
            message: 'Error al publicar equipo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de red en publishEquipment: $e');
      throw ServerException(message: 'No se pudo conectar al servidor.');
    }
  }

  // --- ¡NUEVO MÉTODO AÑADIDO! ---
  @override
  Future<EquipmentModel> unpublishEquipment({required int equipmentId}) async {
    final token = prefs.getString('auth_token');
    if (token == null) throw ServerException(message: 'Token not found');

    final url = Uri.parse('$baseUrl/api/v1/equipments/$equipmentId/rental');
    print('Llamando a API (Unpublish): $url');

    try {
      final response = await client.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Respuesta de Publish (${response.statusCode}): ${response.body}');

      // ✅ Caso 1: la API devuelve éxito sin contenido
      if (response.statusCode == 204) {
        print('Equipo ocultado correctamente (204 No Content)');
        // Devolvemos un modelo vacío, o uno dummy válido
        return EquipmentModel.empty(); // asegúrate de tener este constructor
      }

      // ✅ Caso 2: la API devuelve el objeto actualizado (caso raro)
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return EquipmentModel.fromJson(response.body);
      }

      // ⚠️ Caso 3: error 400 con mensaje conocido (ya estaba oculto)
      if (response.statusCode == 400 &&
          response.body.contains('not published for rent')) {
        print('Aviso: el equipo ya estaba oculto (400 tolerado)');
        return EquipmentModel.empty();
      }

      // ❌ Caso 4: otro error
      print('Error al ocultar: ${response.statusCode} ${response.body}');
      throw ServerException(
          message: 'Error al ocultar equipo: ${response.statusCode}');
    } catch (e) {
      print('Error de red en unpublish: $e');
      throw ServerException(message: 'No se pudo conectar al servidor.');
    }
  }
}





