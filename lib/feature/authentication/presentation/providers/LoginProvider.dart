import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/domain/entities/AuthenticatedUserEntity.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/SignInUseCase.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/VerifyTwoFactorUseCase.dart';
// 1. Importar el nuevo Caso de Uso
import 'package:osito_polar_app/feature/authentication/domain/usecases/InitiateTwoFactorUseCase.dart';

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
  // 2. Declarar la dependencia
  final InitiateTwoFactorUseCase initiateTwoFactorUseCase;
  final SharedPreferences prefs;

  ProviderLoginProvider({
    required this.signInUseCase,
    required this.verifyTwoFactorUseCase,
    required this.initiateTwoFactorUseCase, // 3. Pedirla en el constructor
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

        // CASO 1: Requiere 2FA (Login interceptado)
        if (user.requiresTwoFactorSetup) {
          _tempQrCode = user.qrCodeDataUrl;
          _tempSecret = user.manualEntryKey;
          _tempUsername = user.username;
          _state = LoginState.requires2FA;
        }
        // CASO 2: Login directo
        else if (user.token != null && user.token!.isNotEmpty) {
          _user = user;
          _saveUserToPrefs(user);
          _state = LoginState.success;
        }
        else {
          _errorMessage = "Respuesta desconocida del servidor.";
          _state = LoginState.error;
        }
      },
    );
    notifyListeners();
  }

  // --- LÓGICA: VERIFICAR 2FA (Para Login o Activación) ---
  Future<void> verifyTwoFactor(String code) async {
    _state = LoginState.loading;
    notifyListeners();

    // Usamos el usuario temporal (login) o el actual (configuración)
    final username = _tempUsername ?? _user?.username ?? prefs.getString('username');

    if (username == null) {
      _errorMessage = "Error de sesión. Vuelve a loguearte.";
      _state = LoginState.error;
      notifyListeners();
      return;
    }

    final params = VerifyTwoFactorParams(username: username, code: code);
    final result = await verifyTwoFactorUseCase(params);

    result.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        // Si falla, volvemos a requerir 2FA para que intente de nuevo
        // (OJO: Si estamos en setup, la UI de setup debe manejar esto,
        // pero 'requires2FA' no rompe nada).
        _state = LoginState.error; // Cambiado a error para que la UI muestre el msg rojo
      },
          (user) {
        // ¡Éxito!
        _user = user;
        _saveUserToPrefs(user);
        _state = LoginState.success;
      },
    );
    notifyListeners();
  }

  // --- LÓGICA: GENERAR QR (CONFIGURACIÓN INICIAL) ---
  Future<void> generateTwoFactorSecret() async {
    _state = LoginState.loading;
    notifyListeners();

    final username = _user?.username ?? prefs.getString('username');

    if (username == null) {
      _errorMessage = "No se encontró usuario activo.";
      _state = LoginState.error;
      notifyListeners();
      return;
    }

    _tempUsername = username;

    final result = await initiateTwoFactorUseCase(username);

    result.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = LoginState.error;
      },
          (secretData) {
        _tempQrCode = secretData.qrCodeDataUrl;
        _tempSecret = secretData.manualEntryKey;
        // Mantenemos 'initial' para que la UI muestre los datos sin navegar
        _state = LoginState.initial;
      },
    );
    notifyListeners();
  }

  // --- LIMPIAR ESTADO ---
  void resetState() {
    _state = LoginState.initial;
    _errorMessage = '';
    _tempQrCode = null;
    _tempSecret = null;
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