import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:osito_polar_app/feature/equipment/data/models/EquipmentModel.dart';
import 'EquipmentRemoteDataSource.dart';
import 'package:shared_preferences/shared_preferences.dart';
// 1. Reutilizamos la URL base que definimos en el DataSource de Auth
//    (Asegúrate de que ese archivo la tenga)
//    O mejor, crea un archivo en 'lib/core/util/constants.dart'
const String kBaseUrl = 'http://localhost:5128';

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
      // La API devolvió una lista de equipos
      return EquipmentModel.listFromJson(response.body);
    } else {
      // Error (401, 404, 500, etc.)
      throw Exception('Error al obtener equipos: ${response.statusCode}');
    }
  }
}