import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/core/ui/widgets/OsitoPolarTopBar.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/RegisterProvider.dart';
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
  // --- (Tus controladores no cambian) ---
  int _currentStep = 0;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController(text: 'Peru');

  @override
  void dispose() {
    // --- (Tu 'dispose' no cambia) ---
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

  // --- (Tu lógica de '_buildSteps' no cambia) ---
  List<Step> _buildSteps(BuildContext context, RegisterState state) {
    bool isLoading = (state == RegisterState.creatingCheckout ||
        state == RegisterState.completingRegistration);

    return [
      // --- PASO 1: DATOS DE CUENTA ---
      Step(
        title: const Text(
          'Cuenta',
          style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),
        ),
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
        title: const Text(
          'Empresa',
          style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),
        ),
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
        title: const Text(
          'Dirección',
          style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),
        ),
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

  // --- (Tu lógica de '_submitRegistration' no cambia) ---
  void _submitRegistration() {
    final provider = context.read<RegisterProvider>();
    if (provider.state == RegisterState.creatingCheckout) return;

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

    final checkoutParams = CheckoutParams(
      planId: 4,
      userType: "Provider",
      successUrl: "https://ositopolar-42d82.web.app/registration/success",
      cancelUrl: "https://ositopolar-42d82.web.app/registration/cancel",
    );

    print("Iniciando Paso 1: Creando checkout...");
    provider.createCheckout(formData, checkoutParams);
  }

  // --- (Tu lógica de '_launchStripeCheckout' no cambia) ---
  Future<void> _launchStripeCheckout(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: '_self');
    } else {
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

    // --- (Tu 'WidgetsBinding' no cambia) ---
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state == RegisterState.checkoutCreated) {
        final url = provider.checkoutEntity?.checkoutUrl;
        if (url != null) {
          print("¡Paso 1 Exitoso! Redirigiendo a Stripe: $url");
          _launchStripeCheckout(url);
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
                      Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(context).colorScheme.copyWith(
                            primary: AppColors.primaryButton,
                          ),
                        ),
                        child: Stepper(
                          currentStep: _currentStep,
                          onStepTapped: (step) {
                            if (!isLoading) setState(() => _currentStep = step);
                          },
                          onStepContinue: () {
                            if (_currentStep == 2) {
                              _submitRegistration();
                            } else if (!isLoading) {
                              setState(() => _currentStep += 1);
                            }
                          },
                          onStepCancel: () {
                            if (_currentStep > 0 && !isLoading) {
                              setState(() => _currentStep -= 1);
                            }
                          },
                          steps: _buildSteps(context, state),

                          // ===============================================
                          // == INICIO DE LA CORRECCIÓN 1 (SPINNER) ==
                          // ===============================================
                          controlsBuilder: (context, details) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Column(
                                children: [
                                  // --- Muestra el Error ---
                                  if (state == RegisterState.error)
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 16.0),
                                      child: Text(
                                        provider.errorMessage,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontFamily: 'Inter'),
                                      ),
                                    ),

                                  // --- Muestra el Loading (¡ESTE FALTABA!) ---
                                  if (isLoading)
                                    const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                              AppColors.primaryButton),
                                        )),

                                  // --- Muestra los Botones ---
                                  if (!isLoading)
                                    Wrap(
                                      alignment: WrapAlignment.end,
                                      spacing: 12.0,
                                      runSpacing: 8.0,
                                      children: [
                                        if (_currentStep > 0)
                                          TextButton(
                                            onPressed: details.onStepCancel,
                                            child: const Text(
                                              'Atrás',
                                              style: TextStyle(
                                                  color: AppColors.textLink),
                                            ),
                                          ),
                                        ElevatedButton(
                                          onPressed: details.onStepContinue,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            AppColors.primaryButton,
                                            foregroundColor:
                                            AppColors.buttonLabel,
                                          ),
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
                          // ===============================================
                          // == FIN DE LA CORRECCIÓN 1 ==
                          // ===============================================
                        ),
                      ),

                      const SizedBox(height: 32.0),

                      // ===============================================
                      // == INICIO DE LA CORRECCIÓN 2 (LOGIN OVERFLOW) ==
                      // ===============================================
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4.0,
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
                      // ===============================================
                      // == FIN DE LA CORRECCIÓN 2 ==
                      // ===============================================
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

  /// Helper para campos de texto (no cambia)
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