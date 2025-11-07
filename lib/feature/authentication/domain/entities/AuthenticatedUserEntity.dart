import 'package:equatable/equatable.dart';

/// Esta es la entidad PURA de un usuario logueado.
/// Pertenece a la capa de Dominio. No tiene `fromJson` o `toJson`.
class AuthenticatedUserEntity extends Equatable {
  final int id;
  final String username;
  final String token;

  const AuthenticatedUserEntity({
    required this.id,
    required this.username,
    required this.token,
  });

  @override
  List<Object> get props => [id, username, token];
}