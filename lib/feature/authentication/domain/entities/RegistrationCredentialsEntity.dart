import 'package:equatable/equatable.dart';

class RegistrationCredentialsEntity extends Equatable {
  final String username;
  final String password; // La contraseña generada

  const RegistrationCredentialsEntity({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}