import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:osito_polar_app/core/theme/app_colors.dart';
// Lógica Real
import 'package:osito_polar_app/feature/authentication/presentation/providers/RegisterProvider.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/CreateRegistrationCheckoutUseCase.dart';

class ProviderRegisterPage extends StatefulWidget {
  final VoidCallback? onSignInClicked;

  const ProviderRegisterPage({
    super.key,
    this.onSignInClicked,
  });

  @override
  State<ProviderRegisterPage> createState() => _ProviderRegisterPageState();
}

class _ProviderRegisterPageState extends State<ProviderRegisterPage> {
  int _currentStep = 1; // Empezamos en 1 para coincidir con tu diseño visual (1 y 2)

  // Llaves para validar
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();

  // --- CONTROLADORES (Datos Reales) ---
  // Paso 1
  final _nameController = TextEditingController(); // FirstName
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController(); // (Opcional/Auto)
  final _emailController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _taxIdController = TextEditingController();

  // Paso 2
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController(text: 'Peru');

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _companyNameController.dispose();
    _taxIdController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _zipCodeController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE NEGOCIO (Provider + API) ---

  void _submitRegistration() {
    final provider = context.read<RegisterProvider>();
    if (provider.state == RegisterState.creatingCheckout) return;

    // Mapa de datos para la API
    final formData = {
      // Si no llenó usuario, usamos el email
      "username": _usernameController.text.isNotEmpty ? _usernameController.text : _emailController.text,
      "email": _emailController.text,
      "companyName": _companyNameController.text,
      "taxId": _taxIdController.text.isNotEmpty ? _taxIdController.text : "00000000000",
      "firstName": _nameController.text,
      "lastName": _lastNameController.text,
      "street": _streetController.text,
      "number": _numberController.text,
      "city": _cityController.text,
      "postalCode": _zipCodeController.text,
      "country": _countryController.text,
    };

    final checkoutParams = CheckoutParams(
      planId: 4,
      userType: "Provider",
      successUrl: "https://ositopolar-42d82.web.app/registration/success",
      cancelUrl: "https://ositopolar-42d82.web.app/registration/cancel",
    );

    print("Iniciando Lógica Real: Creando checkout...");
    provider.createCheckout(formData, checkoutParams);
  }

  Future<void> _launchStripeCheckout(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: '_self');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir el pago: $url')),
        );
      }
    }
  }

  // --- LÓGICA DE NAVEGACIÓN VISUAL ---
  void _onNextPressed() {
    if (_step1FormKey.currentState!.validate()) {
      setState(() => _currentStep = 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos el estado real
    final provider = context.watch<RegisterProvider>();
    final state = provider.state;
    final bool isLoading = (state == RegisterState.creatingCheckout);

    // Listener para redirección
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state == RegisterState.checkoutCreated) {
        final url = provider.checkoutEntity?.checkoutUrl;
        if (url != null) {
          _launchStripeCheckout(url);
        }
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // CAPA 1: Fondo Blanco
          Container(color: Colors.white),

          // CAPA 2: Degradado (Diseño Nuevo)
          Opacity(
            opacity: 0.3,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    // Si no tienes estos colores definidos, usa Colors.blue.shade50
                    AppColors.backgroundLight,
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),

          // CAPA 3: Contenido
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Crea una cuenta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.black, // O AppColors.textBlack
                        letterSpacing: -0.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Ya tienes una cuenta ',
                          style: TextStyle(fontSize: 16, color: Color(0xFF667085), fontFamily: 'Inter'),
                        ),
                        GestureDetector(
                          onTap: isLoading ? null : (widget.onSignInClicked ?? () => Navigator.pop(context)),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primaryButton,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Error Message (Lógica Real)
                    if (state == RegisterState.error)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          provider.errorMessage,
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Stepper Visual
                    _buildStepper(),

                    const SizedBox(height: 40),

                    // Formularios
                    if (_currentStep == 1)
                      Form(key: _step1FormKey, child: _buildStep1Form(isLoading))
                    else
                      Form(key: _step2FormKey, child: _buildStep2Form(isLoading)),

                    const SizedBox(height: 40),

                    // Botón de Acción (Diseño Nuevo + Lógica Real)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                          if (_currentStep == 1) {
                            _onNextPressed();
                          } else {
                            if (_step2FormKey.currentState!.validate()) {
                              _submitRegistration(); // <-- ¡Conexión Real!
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryButton,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100), // Borde Redondo Nuevo
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                            : Text(
                          _currentStep == 1 ? 'Siguiente' : 'Pagar y Registrar',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),

                    if (_currentStep == 2)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextButton(
                          onPressed: isLoading ? null : () => setState(() => _currentStep = 1),
                          child: const Text("Atrás", style: TextStyle(color: Colors.grey, fontFamily: 'Inter')),
                        ),
                      ),

                    const SizedBox(height: 30),

                    // Footer
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        const Text(
                          '¿No tienes cuenta? ',
                          style: TextStyle(color: Color(0xFF667085), fontSize: 14, fontFamily: 'Inter'),
                        ),
                        GestureDetector(
                          onTap: () { /* Lógica para ir a registro de cliente si aplica */ },
                          child: const Text(
                            'Regístrate',
                            style: TextStyle(
                              color: AppColors.primaryButton,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS VISUALES (Idénticos al diseño nuevo) ---

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepItem(text: 'Info Personal', number: '1', isActive: _currentStep >= 1),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0), // Ajuste visual
              height: 2,
              color: AppColors.primaryButton,
            ),
          ),
          _buildStepItem(text: 'Dirección', number: '2', isActive: _currentStep >= 2),
        ],
      ),
    );
  }

  Widget _buildStepItem({required String text, required String number, required bool isActive}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primaryButton,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryButton, width: 2),
            color: isActive ? AppColors.primaryButton : Colors.white,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.primaryButton,
                fontWeight: isActive ? FontWeight.w900 : FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep1Form(bool isLoading) {
    return Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: _buildLabel('Nombres *')),
        const SizedBox(height: 8),
        _buildTextField(controller: _nameController, hintText: 'Ej. Oliver', isEnabled: !isLoading, validator: (v) => v!.isEmpty ? 'Requerido' : null),
        const SizedBox(height: 20),

        Align(alignment: Alignment.centerLeft, child: _buildLabel('Apellido *')),
        const SizedBox(height: 8),
        _buildTextField(controller: _lastNameController, hintText: 'Ej. Smith', isEnabled: !isLoading, validator: (v) => v!.isEmpty ? 'Requerido' : null),
        const SizedBox(height: 20),

        Align(alignment: Alignment.centerLeft, child: _buildLabel('Usuario (Opcional)')),
        const SizedBox(height: 8),
        _buildTextField(controller: _usernameController, hintText: 'oliver123', isEnabled: !isLoading),
        const SizedBox(height: 20),

        Align(alignment: Alignment.centerLeft, child: _buildLabel('Email *')),
        const SizedBox(height: 8),
        _buildTextField(controller: _emailController, hintText: 'ejemplo@correo.com', keyboardType: TextInputType.emailAddress, isEnabled: !isLoading, validator: (v) => !v!.contains('@') ? 'Inválido' : null),
        const SizedBox(height: 20),

        Align(alignment: Alignment.centerLeft, child: _buildLabel('Empresa *')),
        const SizedBox(height: 8),
        _buildTextField(controller: _companyNameController, hintText: 'Nombre de tu empresa', isEnabled: !isLoading, validator: (v) => v!.isEmpty ? 'Requerido' : null),
        const SizedBox(height: 20),

        Align(alignment: Alignment.centerLeft, child: _buildLabel('RUC / Tax ID *')),
        const SizedBox(height: 8),
        _buildTextField(controller: _taxIdController, hintText: '20123456789', isEnabled: !isLoading, validator: (v) => v!.isEmpty ? 'Requerido' : null),
      ],
    );
  }

  Widget _buildStep2Form(bool isLoading) {
    return Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: _buildLabel('Calle *')),
        const SizedBox(height: 8),
        _buildTextField(controller: _streetController, hintText: 'Av. Principal', isEnabled: !isLoading, validator: (v) => v!.isEmpty ? 'Requerido' : null),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Número *'),
                  const SizedBox(height: 8),
                  _buildTextField(controller: _numberController, hintText: '123', keyboardType: TextInputType.number, isEnabled: !isLoading, validator: (v) => v!.isEmpty ? 'Requerido' : null),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('C. Postal *'),
                  const SizedBox(height: 8),
                  _buildTextField(controller: _zipCodeController, hintText: '15001', keyboardType: TextInputType.number, isEnabled: !isLoading, validator: (v) => v!.isEmpty ? 'Requerido' : null),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Align(alignment: Alignment.centerLeft, child: _buildLabel('Ciudad *')),
        const SizedBox(height: 8),
        _buildTextField(controller: _cityController, hintText: 'Lima', isEnabled: !isLoading, validator: (v) => v!.isEmpty ? 'Requerido' : null),
        const SizedBox(height: 20),

        Align(alignment: Alignment.centerLeft, child: _buildLabel('País *')),
        const SizedBox(height: 8),
        _buildTextField(controller: _countryController, hintText: 'Perú', isEnabled: !isLoading, validator: (v) => v!.isEmpty ? 'Requerido' : null),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF344054),
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool isEnabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField( // Usamos TextFormField para que funcione el validator
      controller: controller,
      keyboardType: keyboardType,
      enabled: isEnabled,
      validator: validator,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Color(0xFF475467),
        fontFamily: 'Inter',
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE1E7EF), // Color Grisáceo
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 15, fontFamily: 'Inter'),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

        // Bordes Redondos (Píldora)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: AppColors.primaryButton, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}