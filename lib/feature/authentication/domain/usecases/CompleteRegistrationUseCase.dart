import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/domain/repositories/AuthRepository.dart';
import 'package:equatable/equatable.dart';

class CompleteRegistrationUseCase {
  final AuthRepository repository;
  CompleteRegistrationUseCase(this.repository);

  Future<Either<Failure, void>> call(CompleteRegistrationParams params) async {
    // Llama al repositorio con el 'sessionId' y el 'Map' de datos
    return await repository.completeRegistration(
      sessionId: params.sessionId,
      registrationData: params.toJson(),
    );
  }
}

// Este 'Params' tiene TODOS los datos del formulario + el sessionId
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
  // (No necesitamos planId o userType aquí, la API los lee del 'sessionId')

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

  // Genera el Map que la API 'complete-registration' espera
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