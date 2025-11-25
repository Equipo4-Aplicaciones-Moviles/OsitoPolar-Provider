import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/domain/repositories/AuthRepository.dart';
import 'package:equatable/equatable.dart';
// --- ¡AÑADE ESTE IMPORT! ---
import 'package:osito_polar_app/feature/authentication/domain/entities/RegistrationCredentialsEntity.dart';

class CompleteRegistrationUseCase {
  final AuthRepository repository;
  CompleteRegistrationUseCase(this.repository);

  // --- ¡CAMBIO AQUÍ! De 'void' a 'RegistrationCredentialsEntity' ---
  Future<Either<Failure, RegistrationCredentialsEntity>> call(CompleteRegistrationParams params) async {
    return await repository.completeRegistration(
      sessionId: params.sessionId,
      registrationData: params.toJson(),
    );
  }
}

// (La clase 'CompleteRegistrationParams' se queda IGUAL, no hace falta tocarla)
class CompleteRegistrationParams extends Equatable {
  final String sessionId;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String companyName;
  final String taxId;
  final String street;
  final String number;
  final String city;
  final String postalCode;
  final String country;

  const CompleteRegistrationParams({
    required this.sessionId,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.companyName,
    required this.taxId,
    required this.street,
    required this.number,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  Map<String, dynamic> toJson() => {
    "sessionId": sessionId,
    "username": username,
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "companyName": companyName,
    "taxId": taxId,
    "street": street,
    "number": number,
    "city": city,
    "postalCode": postalCode,
    "country": country,
  };

  @override
  List<Object?> get props => [sessionId, username, email];
}