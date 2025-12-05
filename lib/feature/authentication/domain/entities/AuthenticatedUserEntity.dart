import 'package:equatable/equatable.dart';
import 'package:osito_polar_app/feature/provider-module/domain/entities/ProviderProfileEntity.dart';
class AuthenticatedUserEntity extends Equatable {
  final int id;
  final String username;
  final String? token;
  // --- CAMPOS NUEVOS ---
  final String userType;  // "Owner" o "Provider"
  final int profileId;   // El ID de su perfil
  final bool requiresTwoFactorSetup;
  final String? qrCodeDataUrl;
  final String? manualEntryKey;

  const AuthenticatedUserEntity({
    required this.id,
    required this.username,
    this.token,
    // --- CAMPOS NUEVOS ---
    required this.userType,
    required this.profileId,
    this.requiresTwoFactorSetup = false,
    this.qrCodeDataUrl,
    this.manualEntryKey,

  });


  @override
  List<Object?> get props => [id, username, token, userType, profileId, requiresTwoFactorSetup, qrCodeDataUrl, manualEntryKey];
}