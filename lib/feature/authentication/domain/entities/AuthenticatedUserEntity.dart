import 'package:equatable/equatable.dart';

class AuthenticatedUserEntity extends Equatable {
  final int id;
  final String username;
  final String token;
  // --- CAMPOS NUEVOS ---
  final String userType;  // "Owner" o "Provider"
  final int profileId;   // El ID de su perfil

  const AuthenticatedUserEntity({
    required this.id,
    required this.username,
    required this.token,
    // --- CAMPOS NUEVOS ---
    required this.userType,
    required this.profileId,
  });

  @override
  List<Object> get props => [id, username, token, userType, profileId];
}