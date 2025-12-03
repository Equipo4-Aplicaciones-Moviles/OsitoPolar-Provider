import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/domain/entities/AuthenticatedUserEntity.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/SignInUseCase.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/VerifyTwoFactorUseCase.dart';

enum LoginState {
  initial,
  loading,
  success,
  requires2FA,
  error
}

class ProviderLoginProvider extends ChangeNotifier {
  final SignInUseCase signInUseCase;
  final VerifyTwoFactorUseCase verifyTwoFactorUseCase;
  final SharedPreferences prefs;

  ProviderLoginProvider({
    required this.signInUseCase,
    required this.verifyTwoFactorUseCase,
    required this.prefs,
  });

  // --- Estados ---
  LoginState _state = LoginState.initial;
  LoginState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  AuthenticatedUserEntity? _user;
  AuthenticatedUserEntity? get user => _user;

  // --- Datos Temporales para 2FA ---
  String? _tempQrCode;
  String? _tempSecret;
  String? _tempUsername;

  String? get tempQrCode => _tempQrCode;
  String? get tempSecret => _tempSecret;

  // --- LÓGICA: LOGIN ---
  Future<void> signIn(String username, String password) async {
    print("🔵 Provider: Iniciando login para $username...");
    _state = LoginState.loading;
    notifyListeners();

    final failureOrUser = await signInUseCase(username: username, password: password);

    failureOrUser.fold(
          (failure) {
        print("🔴 Provider: Error en login -> $failure");
        _errorMessage = _mapFailureToMessage(failure);
        _state = LoginState.error;
      },
          (user) {
        print("🟢 Provider: API respondió Éxito.");
        print("   -> Usuario: ${user.username}");
        print("   -> Requiere 2FA: ${user.requiresTwoFactorSetup}");
        print("   -> Token: ${user.token != null ? 'SÍ' : 'NO'}");

        // CASO 1: Requiere configurar 2FA o Verificarlo
        if (user.requiresTwoFactorSetup) {
          print("⚠️ Provider: Detectado requerimiento de 2FA. Cambiando estado a requires2FA.");
          _tempQrCode = user.qrCodeDataUrl;
          _tempSecret = user.manualEntryKey;
          _tempUsername = user.username;
          _state = LoginState.requires2FA; // <-- ESTO DISPARA LA NAVEGACIÓN
        }
        // CASO 2: Login directo (tiene token)
        else if (user.token != null && user.token!.isNotEmpty) {
          print("✅ Provider: Login directo. Guardando usuario y cambiando estado a success.");
          _user = user;
          _saveUserToPrefs(user);
          _state = LoginState.success;
        }
        else {
          print("❓ Provider: Respuesta extraña (sin 2FA y sin Token).");
          _errorMessage = "Respuesta desconocida del servidor.";
          _state = LoginState.error;
        }
      },
    );
    notifyListeners();
  }

  // --- LÓGICA: VERIFICAR 2FA ---
  Future<void> verifyTwoFactor(String code) async {
    _state = LoginState.loading;
    notifyListeners();

    if (_tempUsername == null) {
      _errorMessage = "Error de sesión. Vuelve a loguearte.";
      _state = LoginState.error;
      notifyListeners();
      return;
    }

    final params = VerifyTwoFactorParams(username: _tempUsername!, code: code);
    final result = await verifyTwoFactorUseCase(params);

    result.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        // Volvemos al estado 2FA para que el usuario pueda reintentar el código
        _state = LoginState.requires2FA;
      },
          (user) {
        // ¡Éxito! Tenemos el usuario completo con token
        _user = user;
        _saveUserToPrefs(user);
        _state = LoginState.success;
      },
    );
    notifyListeners();
  }

  // --- LÓGICA: LOGOUT ---
  Future<void> logout() async {
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('username');
    await prefs.remove('user_type');
    await prefs.remove('profile_id');

    _user = null;
    _state = LoginState.initial;
    _errorMessage = '';

    print("Logout exitoso. Datos borrados.");
    notifyListeners();
  }

  Future<void> _saveUserToPrefs(AuthenticatedUserEntity user) async {
    if (user.token != null) {
      await prefs.setString('auth_token', user.token!);
    }

    await prefs.setInt('user_id', user.id);
    await prefs.setString('username', user.username);

    if (user.userType != null) {
      await prefs.setString('user_type', user.userType!);
    }

    if (user.profileId != null) {
      await prefs.setInt('profile_id', user.profileId!);
    }

    print('Datos de usuario guardados en SharedPreferences.');
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure && failure.message != null) {
      return failure.message!;
    }
    return 'Un error inesperado ocurrió.';
  }
}