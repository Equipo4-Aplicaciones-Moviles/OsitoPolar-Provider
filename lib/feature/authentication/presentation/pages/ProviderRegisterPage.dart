import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // (Asegúrate de tener 'url_launcher' en pubspec.yaml)

import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/core/ui/widgets/OsitoPolarTopBar.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/RegisterProvider.dart';
// Importamos los "Params" de los UseCases para saber qué datos necesitamos
import 'package:osito_polar_app/feature/authentication/domain/usecases/CreateRegistrationCheckoutUseCase.dart';

/// Pantalla de Registro para Providers, ahora como un "wizard" de 3 pasos.
class ProviderRegisterPage extends StatefulWidget {
  final VoidCallback onSignInClicked;

  const ProviderRegisterPage({
    super.key,
    required this.onSignInClicked,
  });

  @override
  State<ProviderRegisterPage> createState() => _ProviderRegisterPageState();
}

class _ProviderRegisterPageState extends State<ProviderRegisterPage> {
  // --- Controladores para el Stepper ---
  int _currentStep = 0;

  // --- Controladores para TODOS los campos de la API ---

  // Paso 1: Cuenta
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  // Paso 2: Empresa
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _taxIdController = TextEditingController(); // RUC/Identificador Fiscal

  // Paso 3: Dirección
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController(text: 'Peru'); // Valor por defecto

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyNameController.dispose();
    _taxIdController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  // --- Método para construir los 3 pasos del wizard ---
  List<Step> _buildSteps(BuildContext context, RegisterState state) {
    bool isLoading = (state == RegisterState.creatingCheckout ||
        state == RegisterState.completingRegistration);

    return [
      // --- PASO 1: DATOS DE CUENTA ---
      Step(
        title: const Text('Cuenta'),
        content: Column(
          children: [
            _buildTextField(
              controller: _usernameController,
              labelText: 'Username (para login)',
              isEnabled: !isLoading,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              labelText: 'Email (para notificaciones)',
              keyboardType: TextInputType.emailAddress,
              isEnabled: !isLoading,
            ),
          ],
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      // --- PASO 2: DATOS DE EMPRESA ---
      Step(
        title: const Text('Empresa'),
        content: Column(
          children: [
            _buildTextField(
              controller: _companyNameController,
              labelText: 'Nombre de la Empresa',
              isEnabled: !isLoading,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _taxIdController,
              labelText: 'RUC / ID Fiscal',
              isEnabled: !isLoading,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _firstNameController,
              labelText: 'Nombre (Contacto)',
              isEnabled: !isLoading,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _lastNameController,
              labelText: 'Apellido (Contacto)',
              isEnabled: !isLoading,
            ),
          ],
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      // --- PASO 3: DIRECCIÓN DE FACTURACIÓN ---
      Step(
        title: const Text('Dirección'),
        content: Column(
          children: [
            _buildTextField(
              controller: _streetController,
              labelText: 'Calle',
              isEnabled: !isLoading,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _numberController,
              labelText: 'Número / Apartamento',
              isEnabled: !isLoading,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _cityController,
              labelText: 'Ciudad',
              isEnabled: !isLoading,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _postalCodeController,
              labelText: 'Código Postal',
              isEnabled: !isLoading,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _countryController,
              labelText: 'País',
              isEnabled: !isLoading,
            ),
          ],
        ),
        isActive: _currentStep >= 2,
        state: _currentStep == 2 ? StepState.editing : StepState.indexed,
      ),
    ];
  }

  // --- Método que se llama al presionar "Continuar" en el último paso ---
  void _submitRegistration() {
    final provider = context.read<RegisterProvider>();
    if (provider.state == RegisterState.creatingCheckout) return;

    // 1. Guardamos TODOS los datos del formulario en un Map
    final formData = {
      "username": _usernameController.text,
      "email": _emailController.text,
      "companyName": _companyNameController.text,
      "taxId": _taxIdController.text,
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "street": _streetController.text,
      "number": _numberController.text,
      "city": _cityController.text,
      "postalCode": _postalCodeController.text,
      "country": _countryController.text,
    };

    // 2. Creamos los 'Params' para la PRIMERA llamada
    final checkoutParams = CheckoutParams(
      planId: 4, // (Ejemplo, debes obtener esto de una selección de plan)
      userType: "Provider",
      // ¡IMPORTANTE! Añade '/#' para el ruteo de Flutter Web
      successUrl: "http://localhost:3000/#/registration/success",
      cancelUrl: "http://localhost:3000/#/registration/cancel",
    );

    // 3. Llamamos al provider
    print("Iniciando Paso 1: Creando checkout...");
    provider.createCheckout(formData, checkoutParams);
  }

  // --- Método para lanzar la URL de Stripe ---
  Future<void> _launchStripeCheckout(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      // 'webOnlyWindowName: _self' intenta abrirlo en la misma pestaña
      await launchUrl(uri, webOnlyWindowName: '_self');
    } else {
      // Si falla, muestra un error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir la página de pago: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegisterProvider>();
    final state = provider.state;
    final isLoading = (state == RegisterState.creatingCheckout ||
        state == RegisterState.completingRegistration);

    // --- LISTENER DE ESTADO ---
    // Escucha cambios en el provider para actuar (como lanzar la URL)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ¡Reaccionamos solo a 'checkoutCreated'!
      if (state == RegisterState.checkoutCreated) {
        final url = provider.checkoutEntity?.checkoutUrl;
        if (url != null) {
          print("¡Paso 1 Exitoso! Redirigiendo a Stripe: $url");
          // ¡Lanza la URL de Stripe!
          _launchStripeCheckout(url);
          // ¡NO reseteamos el estado! Necesitamos los datos guardados
          // para el Paso 2.
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: OsitoPolarTopBar(
        onMenuClicked: () {
          // TODO: Implementar lógica del drawer
        },
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 0,
                color: AppColors.cardBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: const BorderSide(color: AppColors.cardBorder, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 48.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Crear Cuenta de Proveedor',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.title,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // --- WIZARD (STEPPER) ---
                      Stepper(
                        currentStep: _currentStep,
                        onStepTapped: (step) {
                          if (!isLoading) setState(() => _currentStep = step);
                        },
                        onStepContinue: () {
                          if (_currentStep == 2) {
                            // Si es el último paso, llama a la API
                            _submitRegistration();
                          } else if (!isLoading) {
                            // Si no, avanza al siguiente paso
                            setState(() => _currentStep += 1);
                          }
                        },
                        onStepCancel: () {
                          if (_currentStep > 0 && !isLoading) {
                            setState(() => _currentStep -= 1);
                          }
                        },
                        steps: _buildSteps(context, state),
                        controlsBuilder: (context, details) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Column(
                              children: [
                                // --- Muestra el Error ---
                                if (state == RegisterState.error)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: Text(
                                      provider.errorMessage,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),

                                // --- Muestra el Loading ---
                                if (isLoading)
                                  const Center(
                                      child: CircularProgressIndicator()),

                                // --- Muestra los Botones ---
                                if (!isLoading)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (_currentStep > 0)
                                        TextButton(
                                          onPressed: details.onStepCancel,
                                          child: const Text('Atrás'),
                                        ),
                                      const SizedBox(width: 12),
                                      ElevatedButton(
                                        onPressed: details.onStepContinue,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          AppColors.primaryButton,
                                          foregroundColor:
                                          AppColors.buttonLabel,
                                        ),
                                        // Cambia el texto del botón en el último paso
                                        child: Text(
                                          _currentStep == 2
                                              ? 'Ir a Pagar'
                                              : 'Continuar',
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32.0),
                      // --- ENLACE A "SIGN IN" ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(color: AppColors.textColor),
                          ),
                          TextButton(
                            onPressed:
                            isLoading ? null : widget.onSignInClicked,
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  color: AppColors.textLink,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper para campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    bool isEnabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: isEnabled,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: AppColors.textFieldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:
          const BorderSide(color: AppColors.textFieldBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:
          const BorderSide(color: AppColors.textFieldBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:
          const BorderSide(color: AppColors.primaryButton, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textColor),
      ),
      keyboardType: keyboardType,
    );
  }
}