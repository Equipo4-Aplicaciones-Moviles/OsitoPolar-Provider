import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:osito_polar_app/feature/equipment/data/models/EquipmentModel.dart';
import 'package:osito_polar_app/feature/equipment/data/models/CreateEquipmentModel.dart';
import 'EquipmentRemoteDataSource.dart';
import 'package:shared_preferences/shared_preferences.dart';
// 1. Reutilizamos la URL base que definimos en el DataSource de Auth
//    (Asegúrate de que ese archivo la tenga)
//    O mejor, crea un archivo en 'lib/core/util/constants.dart'
const String kBaseUrl = 'http://localhost:8080';

class EquipmentRemoteDataSourceImpl implements EquipmentRemoteDataSource {
  final http.Client client;
  final SharedPreferences prefs;

  EquipmentRemoteDataSourceImpl({required this.client,required this.prefs,});

  @override
  Future<List<EquipmentModel>> getEquipments() async {
    final uri = Uri.parse('$kBaseUrl/api/v1/equipments');

    print('Llamando a API: $uri');

    // 2. ¡IMPORTANTE! Esta llamada necesita un Token de autenticación.
    //    Cuando el login real funcione, tendremos que leer el token
    //    de SharedPreferences y añadirlo a los headers.
    //    Por ahora, la llamada fallará (probablemente con un 401),
    //    ¡y eso está bien! Estamos construyendo las tuberías.

    // --- ¡AÑADIDO! Leemos el token guardado ---
    final token = prefs.getString('auth_token');
    if (token == null) {
      print('¡Error! No se encontró token. El usuario no está logueado.');
      throw Exception('Token no encontrado');
    }
    final response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // <-- AÑADIR ESTO EN EL FUTURO
      },
    );

    print('Respuesta de Equipos: ${response.statusCode}');

    if (response.statusCode == 200) {
      return EquipmentModel.listFromJson(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Token inválido o expirado (401)');
    } else {
      throw Exception('Error al obtener equipos: ${response.statusCode}');
    }
  }

  @override
  Future<EquipmentModel> createEquipment(CreateEquipmentModel equipment) async {
    final uri = Uri.parse('$kBaseUrl/api/v1/equipments');
    print('Llamando a API (POST): $uri');

    // 1. Obtenemos el token (necesario para crear)
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('Token no encontrado');
    }

    try {
      final response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // 2. Enviamos el JSON del nuevo equipo en el body
        body: equipment.toJson(),
      );

      print('Respuesta de Crear Equipo: ${response.statusCode}');

      // 3. Tu API (Swagger) dice que devuelve 201 (Created)
      if (response.statusCode == 201) {
        // Devuelve el equipo recién creado
        return EquipmentModel.fromJson(response.body);
      } else {
        // Error (400, 401, etc.)
        print('Error de API: ${response.body}');
        throw Exception('Error al crear el equipo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de red: $e');
      throw Exception('No se pudo conectar al servidor.');
    }
  }

  @override
  Future<EquipmentModel> getEquipmentById(int equipmentId) async {
    // Construimos la URL con el ID
    final uri = Uri.parse('$kBaseUrl/api/v1/equipments/$equipmentId');
    print('Llamando a API: $uri');

    // Obtenemos el token (necesario para ver un equipo)
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('Token no encontrado');
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
        // Devuelve el equipo único
        return EquipmentModel.fromJson(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Equipo no encontrado (404)');
      } else {
        print('Error de API: ${response.body}');
        throw Exception('Error al obtener el equipo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de red: $e');
      throw Exception('No se pudo conectar al servidor.');
    }
  }

  @override
  Future<void> deleteEquipment(int equipmentId) async {
    final uri = Uri.parse('$kBaseUrl/api/v1/equipments/$equipmentId');
    print('Llamando a API (DELETE): $uri');

    // Obtenemos el token (necesario para borrar)
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('Token no encontrado');
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

      // 3. Tu API (Swagger) dice que devuelve 204 (No Content)
      if (response.statusCode == 204) {
        // ¡Éxito! No hay cuerpo que devolver.
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Equipo no encontrado (404)');
      } else {
        // Error (400, 401, etc.)
        print('Error de API: ${response.body}');
        throw Exception('Error al borrar el equipo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de red: $e');
      throw Exception('No se pudo conectar al servidor.');
    }
  }

  @override
  Future<EquipmentModel> updateEquipment(
      int equipmentId, CreateEquipmentModel equipment) async {
    final uri = Uri.parse('$kBaseUrl/api/v1/equipments/$equipmentId');
    print('Llamando a API (PUT): $uri');

    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('Token no encontrado');
    }

    try {
      final response = await client.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: equipment.toJson(), // Enviamos el JSON actualizado
      );

      print('Respuesta de Update Equipo: ${response.statusCode}');

      // Tu API (Swagger) dice que devuelve 200 (OK)
      if (response.statusCode == 200) {
        // Devuelve el equipo actualizado
        return EquipmentModel.fromJson(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Equipo no encontrado (404)');
      } else if (response.statusCode == 400) {
        print('Error de API (400): ${response.body}');
        throw Exception('Error de validación: ${response.statusCode}');
      } else {
        print('Error de API: ${response.body}');
        throw Exception('Error al actualizar el equipo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de red: $e');
      throw Exception('No se pudo conectar al servidor.');
    }
  }
}