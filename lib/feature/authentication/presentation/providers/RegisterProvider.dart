import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/CreateRegistrationCheckoutUseCase.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/CompleteRegistrationUseCase.dart';
import 'package:osito_polar_app/feature/authentication/domain/entities/RegistrationCheckoutEntity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/RegistrationCredentialsEntity.dart';


enum RegisterState {
  initial,
  creatingCheckout,
  checkoutCreated,
  completingRegistration,
  registrationComplete,
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

  Map<String, dynamic> _formData = {};
  String? _sessionId;
  RegistrationCheckoutEntity? _checkoutEntity;
  RegistrationCheckoutEntity? get checkoutEntity => _checkoutEntity;

  static const _kFormDataKey = 'temp_reg_form_data';
  static const _kSessionIdKey = 'temp_reg_session_id';


  bool _isCompleting = false;
  RegistrationCredentialsEntity? _credentials;

  // 2. Getter para que la UI pueda leerla
  RegistrationCredentialsEntity? get credentials => _credentials;

  /// Llamado desde 'ProviderRegisterPage'
  Future<void> createCheckout(
      Map<String, dynamic> formData,
      CheckoutParams checkoutParams,
      ) async {
    _state = RegisterState.creatingCheckout;
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
        prefs.setString(_kSessionIdKey, checkout.sessionId);
        _state = RegisterState.checkoutCreated;
      },
    );
    notifyListeners();
  }

  /// Llamado desde 'RegistrationSuccessPage'
  Future<void> completeRegistration(String sessionIdFromUrl) async {


    if (_isCompleting || _state == RegisterState.registrationComplete) {
      print("¡IGNORANDO LLAMADA DOBLE a completeRegistration!");
      return;
    }

    _isCompleting = true;
    // --------------------------------------------------

    final formDataString = prefs.getString(_kFormDataKey);
    final savedSessionId = prefs.getString(_kSessionIdKey);


    if (formDataString == null || formDataString.isEmpty || savedSessionId == null) {
      _errorMessage = "Error: No se encontraron datos de registro. Intenta de nuevo.";
      _state = RegisterState.error;
      _isCompleting = false;
      notifyListeners();
      return;
    }

    if (sessionIdFromUrl != savedSessionId) {
      _errorMessage = "Error: El ID de sesión no coincide. Intenta el proceso de nuevo.";
      _state = RegisterState.error;
      _isCompleting = false;
      notifyListeners();
      return;
    }

    final formDataMap = jsonDecode(formDataString) as Map<String, dynamic>;

    _state = RegisterState.completingRegistration;
    notifyListeners();

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
        _isCompleting = false;
      },
          (credentialsEntity) {
        _credentials = credentialsEntity; // <-- ¡Guardamos aquí!
        _state = RegisterState.registrationComplete;
        _clearRegistrationData();
      },
    );
    notifyListeners();
  }

  void _clearRegistrationData() {
    _checkoutEntity = null;
    prefs.remove(_kFormDataKey);
    prefs.remove(_kSessionIdKey);
  }

  void resetState() {
    _state = RegisterState.initial;
    _errorMessage = '';
    _clearRegistrationData();
    _isCompleting = false;
    notifyListeners();
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Error del servidor. Revisa los campos.';
    }
    if (failure is NetworkFailure) {
      return 'Error de red: ${failure.message}';
    }
    return 'Un error inesperado ocurrió.';
  }
}