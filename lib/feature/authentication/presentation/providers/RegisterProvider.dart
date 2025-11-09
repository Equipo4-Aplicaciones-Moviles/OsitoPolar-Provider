import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/SignUpUseCase.dart';

/// Define los posibles estados de la UI para el registro.
enum RegisterState {
  initial,
  loading,
  success,
  error
}

/// El "ViewModel" para la pantalla de Registro.
class RegisterProvider extends ChangeNotifier {
  final SignUpUseCase signUpUseCase;

  RegisterProvider({required this.signUpUseCase});

  // --- Estados de la UI ---
  RegisterState _state = RegisterState.initial;
  RegisterState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // --- Lógica de Negocio ---

  /// Método principal que la UI llamará al presionar "Sign Up".
  Future<void> signUp(String username, String password) async {
    _state = RegisterState.loading;
    notifyListeners();

    // 2. Llama al Caso de Uso (UseCase)
    final failureOrSuccess = await signUpUseCase(
      username: username,
      password: password,
    );

    // 3. Maneja la respuesta (Either<Failure, void>)
    failureOrSuccess.fold(
          (failure) {
        // --- Caso de Error ---
        _errorMessage = _mapFailureToMessage(failure);
        _state = RegisterState.error;
      },
          (_) {
        // --- Caso de Éxito ---
        _state = RegisterState.success;
      },
    );

    // 4. Notifica a la UI sobre el nuevo estado (éxito o error)
    notifyListeners();
  }

  /// Resetea el estado para un nuevo registro
  void resetState() {
    _state = RegisterState.initial;
    _errorMessage = '';
    notifyListeners();
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
      // TODO: Mejorar mensajes (ej. "Ese usuario ya existe")
        return 'Error del servidor. Inténtalo más tarde.';
      default:
        return 'Un error inesperado ocurrió.';
    }
  }
}