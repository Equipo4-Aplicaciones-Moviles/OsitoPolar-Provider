import 'dart:convert';

/// Representa el JSON que RECIBIMOS del endpoint:
/// POST /api/v1/authentication/sign-in
///
/// Basado en el schema: AuthenticatedUserResource
class AuthenticatedUserModel {
  final int id;
  final String username;
  final String token;

  AuthenticatedUserModel({
    required this.id,
    required this.username,
    required this.token,
  });

  /// Convierte un String JSON (la respuesta del API) en nuestro objeto
  factory AuthenticatedUserModel.fromJson(String str) =>
      AuthenticatedUserModel.fromMap(json.decode(str));

  /// Convierte un Map (después de decodificar el JSON) en nuestro objeto
  factory AuthenticatedUserModel.fromMap(Map<String, dynamic> json) =>
      AuthenticatedUserModel(
        id: json['id'],
        username: json['username'],
        token: json['token'],
      );
}

