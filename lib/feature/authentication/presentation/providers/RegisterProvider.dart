import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/CreateRegistrationCheckoutUseCase.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/CompleteRegistrationUseCase.dart';
import 'package:osito_polar_app/feature/authentication/domain/entities/RegistrationCheckoutEntity.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Estados para CADA paso del flujo
enum RegisterState {
  initial, // (El formulario)
  creatingCheckout, // (Llamando a la API - Paso 1)
  checkoutCreated,  // (¡Tenemos URL! Esperando que el usuario pague)
  completingRegistration, // (Llamando a la API - Paso 2)
  registrationComplete, // (¡Éxito total!)
  error
}

class RegisterProvider extends ChangeNotifier {
  final CreateRegistrationCheckoutUseCase createRegistrationCheckoutUseCase;
  final CompleteRegistrationUseCase completeRegistrationUseCase;
  final SharedPreferences prefs;

  RegisterProvider({
    required this.createRegistrationCheckoutUseCase,
    required this.completeRegistrationUseCase,
    required this.prefs,
  });

  RegisterState _state = RegisterState.initial;
  RegisterState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // --- ¡NUEVO! Estado temporal para guardar los datos ---
  Map<String, dynamic> _formData = {};
  String? _sessionId;
  RegistrationCheckoutEntity? _checkoutEntity;
  RegistrationCheckoutEntity? get checkoutEntity => _checkoutEntity;

  static const _kFormDataKey = 'temp_reg_form_data';
  static const _kSessionIdKey = 'temp_reg_session_id';

  /// PASO 1: Llamado desde 'ProviderRegisterPage'
  Future<void> createCheckout(
      Map<String, dynamic> formData,
      CheckoutParams checkoutParams,
      ) async {
    _state = RegisterState.creatingCheckout;
    // ¡Guardamos los datos del formulario!
    _formData = formData;
    notifyListeners();

    try {
      final formDataString = jsonEncode(formData);
      await prefs.setString(_kFormDataKey, formDataString);
      print("Datos del formulario guardados en SharedPreferences.");
    } catch (e) {
      _errorMessage = "Error al guardar datos temporalmente. Intenta de nuevo.";
      _state = RegisterState.error;
      notifyListeners();
      return;
    }

    final failureOrCheckout = await createRegistrationCheckoutUseCase(checkoutParams);

    failureOrCheckout.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = RegisterState.error;
        _clearRegistrationData();
      },
          (checkout) {
        _checkoutEntity = checkout;
        // ¡Guardamos el sessionId!
        prefs.setString(_kSessionIdKey, checkout.sessionId);
        _state = RegisterState.checkoutCreated;
        //_sessionId = checkout.sessionId;
        //_state = RegisterState.checkoutCreated;
      },
    );
    notifyListeners();

  }

  /// PASO 2: Llamado desde 'RegistrationSuccessPage'
  Future<void> completeRegistration(String sessionIdFromUrl) async {

    final formDataString = prefs.getString(_kFormDataKey);
    final savedSessionId = prefs.getString(_kSessionIdKey);


    if (formDataString == null || formDataString.isEmpty || savedSessionId == null) {
      // ¡ESTE ES EL ERROR QUE ESTÁS VIENDO!
      _errorMessage = "Error: No se encontraron datos de registro. Intenta de nuevo.";
      _state = RegisterState.error;
      notifyListeners();
      return;
    }

    // (Opcional) Comprobar que el ID de sesión de la URL coincida con el guardado
    if (sessionIdFromUrl != savedSessionId) {
      _errorMessage = "Error: El ID de sesión no coincide. Intenta el proceso de nuevo.";
      _state = RegisterState.error;
      notifyListeners();
      return;
    }

    // ¡Decodificamos los datos!
    final formDataMap = jsonDecode(formDataString) as Map<String, dynamic>;
    // -----------------------------

    _state = RegisterState.completingRegistration;
    notifyListeners();

    // Creamos los Params para el UseCase
    final params = CompleteRegistrationParams(
      sessionId: sessionIdFromUrl,
      username: formDataMap['username'],
      email: formDataMap['email'],
      firstName: formDataMap['firstName'],
      lastName: formDataMap['lastName'],
      companyName: formDataMap['companyName'],
      taxId: formDataMap['taxId'],
      street: formDataMap['street'],
      number: formDataMap['number'],
      city: formDataMap['city'],
      postalCode: formDataMap['postalCode'],
      country: formDataMap['country'],
    );

    final failureOrSuccess = await completeRegistrationUseCase(params);

    failureOrSuccess.fold(
          (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _state = RegisterState.error;
        // No limpiamos los datos, para que puedan reintentar
      },
          (success) {
        _state = RegisterState.registrationComplete;
        _clearRegistrationData(); // ¡Éxito! Limpiamos los datos temporales
      },
    );
    notifyListeners();
  }

  // Limpia los datos temporales
  void _clearRegistrationData() {
    _checkoutEntity = null;
    // --- ¡LIMPIAR SHARED PREFS! ---
    prefs.remove(_kFormDataKey);
    prefs.remove(_kSessionIdKey);
  }

  void resetState() {
    _state = RegisterState.initial;
    _errorMessage = '';
    _clearRegistrationData(); // Asegura que todo esté limpio al resetear
    notifyListeners();
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Error del servidor. Revisa los campos.';
    }
    return 'Un error inesperado ocurrió.';
  }
}