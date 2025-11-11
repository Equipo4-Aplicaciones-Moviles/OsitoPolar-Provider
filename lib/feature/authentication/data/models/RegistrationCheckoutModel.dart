// --- ¡ARCHIVO NUEVO! ---
// feature/authentication/data/models/RegistrationCheckoutModel.dart
import 'dart:convert';
import 'package:osito_polar_app/feature/authentication/domain/entities/RegistrationCheckoutEntity.dart';

class RegistrationCheckoutModel {
  final String checkoutUrl;
  final String sessionId;

  RegistrationCheckoutModel({
    required this.checkoutUrl,
    required this.sessionId,
  });

  factory RegistrationCheckoutModel.fromJson(String str) =>
      RegistrationCheckoutModel.fromMap(json.decode(str));

  factory RegistrationCheckoutModel.fromMap(Map<String, dynamic> json) =>
      RegistrationCheckoutModel(
        checkoutUrl: json['checkoutUrl'],
        sessionId: json['sessionId'],
      );

  RegistrationCheckoutEntity toEntity() {
    return RegistrationCheckoutEntity(
      checkoutUrl: checkoutUrl,
      sessionId: sessionId,
    );
  }
}