import 'package:http/http.dart' as http;
// Usamos tus nombres de archivo 'PascalCase'
import 'package:osito_polar_app/feature/authentication/data/models/SignInRequestModel.dart';
import 'package:osito_polar_app/feature/authentication/data/models/AuthenticatedUserModel.dart';
import 'package:osito_polar_app/feature/authentication/data/datasource/AuthRemoteDataSource.dart';

// --- ¡SOLUCIÓN AQUÍ! ---
// Como estás compilando para Windows, 'localhost' SÍ funciona.
// Añadimos 'http://'
const String kBaseUrl = 'http://localhost:5128';

// NOTA: Si alguna vez pruebas en un Emulador de Android,
// deberás cambiar esta línea a:
// const String kBaseUrl = 'http://10.0.2.2:5128';
// ---

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthenticatedUserModel> signIn(SignInRequestModel request) async {
    // Usamos el kBaseUrl con tu endpoint de la API
    final uri = Uri.parse('$kBaseUrl/api/v1/authentication/sign-in');

    print('Llamando a la API: $uri'); // <-- Bueno para debugging

    try {
      final response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: request.toJson(), // Usamos el modelo que creamos
      );

      print('Respuesta de la API: ${response.statusCode}'); // <-- Bueno para debugging

      if (response.statusCode == 200) {
        // Si el login es exitoso, convertimos la respuesta JSON
        // en nuestro modelo AuthenticatedUserModel
        return AuthenticatedUserModel.fromJson(response.body);
      } else {
        // TODO: Manejar errores (401, 404, 500)
        print('Error de API: ${response.body}');
        throw Exception('Error al iniciar sesión: ${response.statusCode}');
      }
    } catch (e) {
      // Captura errores de red (ej. si el servidor no está corriendo)
      print('Error de red: $e');
      throw Exception('No se pudo conectar al servidor.');
    }
  }
}