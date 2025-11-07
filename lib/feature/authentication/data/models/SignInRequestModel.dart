import 'dart:convert';

/// Representa el JSON que ENVIAMOS al endpoint:
/// POST /api/v1/authentication/sign-in
///
/// Basado en el schema: SignInResource
class SignInRequestModel {
  final String username;
  final String password;

  SignInRequestModel({
    required this.username,
    required this.password,
  });

  /// Convierte nuestro objeto de Dart a un String JSON para enviar en el body
  String toJson() => json.encode({
    'username': username,
    'password': password,
  });
}