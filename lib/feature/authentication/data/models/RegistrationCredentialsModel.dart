import 'dart:convert';
import 'package:osito_polar_app/feature/authentication/domain/entities/RegistrationCredentialsEntity.dart';

class RegistrationCredentialsModel extends RegistrationCredentialsEntity {
  const RegistrationCredentialsModel({
    required super.username,
    required super.password,
  });

  factory RegistrationCredentialsModel.fromJson(String str) =>
      RegistrationCredentialsModel.fromMap(json.decode(str));

  factory RegistrationCredentialsModel.fromMap(Map<String, dynamic> json) {
    return RegistrationCredentialsModel(
      username: json['username'] ?? '',
      // ¡OJO! La API devuelve 'generatedPassword'
      password: json['generatedPassword'] ?? '',
    );
  }

  RegistrationCredentialsEntity toEntity() => this;
}