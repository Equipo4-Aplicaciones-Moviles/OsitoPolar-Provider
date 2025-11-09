import 'dart:convert';

/// Representa el JSON que ENVIAMOS al endpoint:
/// POST /api/v1/authentication/sign-up
///
/// Basado en el schema: SignUpResource
class SignUpRequestModel {
  final String username;
  final String password;

  SignUpRequestModel({
    required this.username,
    required this.password,
  });

  /// Convierte nuestro objeto de Dart a un String JSON para enviar en el body
  String toJson() => json.encode({
    'username': username,
    'password': password,
  });
}