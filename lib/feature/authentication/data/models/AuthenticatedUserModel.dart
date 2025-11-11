import 'dart:convert';
import 'package:osito_polar_app/feature/authentication/domain/entities/AuthenticatedUserEntity.dart';

class AuthenticatedUserModel {
  final int id;
  final String username;
  final String token;
  // --- CAMPOS NUEVOS ---
  final String userType;
  final int profileId;

  AuthenticatedUserModel({
    required this.id,
    required this.username,
    required this.token,
    // --- CAMPOS NUEVOS ---
    required this.userType,
    required this.profileId,
  });

  factory AuthenticatedUserModel.fromJson(String str) =>
      AuthenticatedUserModel.fromMap(json.decode(str));

  factory AuthenticatedUserModel.fromMap(Map<String, dynamic> json) =>
      AuthenticatedUserModel(
        id: json['id'],
        username: json['username'],
        token: json['token'],
        // --- CAMPOS NUEVOS ---
        userType: json['userType'],
        profileId: json['profileId'],
      );

  // Helper para convertir el Modelo (Datos) a Entidad (Dominio)
  AuthenticatedUserEntity toEntity() {
    return AuthenticatedUserEntity(
      id: id,
      username: username,
      token: token,
      userType: userType,
      profileId: profileId,
    );
  }
}