import 'package:flutter/material.dart';
// ¡Actualizado para usar tus imports 'PascalCase'!
import 'package:shared_preferences/shared_preferences.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/domain/entities/AuthenticatedUserEntity.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/SignInUseCase.dart';

/// Define los posibles estados de la UI para el login.
enum LoginState {
  initial, // Estado inicial, no se ha hecho nada
  loading, // Cargando, muestra un Spinner
  success, // Éxito, navega a la siguiente pantalla
  error    // Error, muestra un mensaje
}

/// El "ViewModel" para la pantalla de Login del Proveedor.
/// ¡Esta es la clase que se llama 'ProviderLoginProvider'!
class ProviderLoginProvider extends ChangeNotifier {
  final SignInUseCase signInUseCase;
  final SharedPreferences prefs;
  ProviderLoginProvider(
      {required this.signInUseCase,
        required this.prefs,});

  // --- Estados de la UI ---
  LoginState _state = LoginState.initial;
  LoginState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  AuthenticatedUserEntity? _user;
  AuthenticatedUserEntity? get user => _user;

  // --- Lógica de Negocio ---

  /// Método principal que la UI llamará al presionar "Sign In".
  Future<void> signIn(String username, String password) async {
    // 1. Pone el estado en "cargando" y notifica a la UI
    _state = LoginState.loading;
    notifyListeners();

    // 2. Llama al Caso de Uso (UseCase)
    final failureOrUser = await signInUseCase(
      username: username,
      password: password,
    );

    // 3. Maneja la respuesta (Either<Failure, User>)
    failureOrUser.fold(
          (failure) {
        // --- Caso de Error ---
        _errorMessage = _mapFailureToMessage(failure);
        _state = LoginState.error;
      },
          (user) {
        // --- Caso de Éxito ---
        _user = user;
        _state = LoginState.success;

        // TODO: Guardar el user.token en SharedPreferences (LocalStorage)
        print('Login exitoso. Guardando token: ${user.token}');
        _saveTokenToPrefs(user.token);

      },
    );

    // 4. Notifica a la UI sobre el nuevo estado (éxito o error)
    notifyListeners();
  }

  Future<void> _saveTokenToPrefs(String token) async {
    await prefs.setString('auth_token', token);
  }

  /// Convierte un objeto Failure en un mensaje legible para el usuario.
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
      // TODO: Mejorar mensajes (ej. "Usuario o contraseña incorrecta")
        return 'Error del servidor. Inténtalo más tarde.';
    // (Asumiendo que no tienes NetworkFailure.dart)
    // case NetworkFailure:
    //   return 'No hay conexión a internet.';
      default:
        return 'Un error inesperado ocurrió.';
    }
  }
}