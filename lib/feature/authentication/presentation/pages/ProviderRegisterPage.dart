import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
// Asegúrate de que la ruta de importación sea la correcta según tu proyecto
import 'ProviderRegistrationSuccessPage.dart';

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
  // --- ESTADO ---
  int _currentStep = 1;
  bool _isLoading = false;

  // Llaves para validar formularios
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();

  // --- CONTROLADORES PASO 1 ---
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();

  // --- CONTROLADORES PASO 2 ---
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  void dispose() {
    // Limpieza de controladores
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _companyNameController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _zipCodeController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE NAVEGACIÓN ---

  void _onNextPressed() {
    // Validamos el paso 1 antes de avanzar
    if (_step1FormKey.currentState!.validate()) {
      setState(() {
        _currentStep = 2;
      });
    }
  }

  Future<void> _onSubmitPressed() async {
    // Validamos el paso 2 antes de enviar
    if (_step2FormKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulación de llamada a API (2 segundos)
      await Future.delayed(const Duration(seconds: 2));

      // Generamos una contraseña temporal simulada
      // (En una app real, esto vendría del backend o se enviaría por email)
      final tempPassword = "Prov-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";
      final tempUsername = _emailController.text.isNotEmpty
          ? _emailController.text
          : _nameController.text;

      if (mounted) {
        setState(() => _isLoading = false);

        // AQUÍ ESTÁ LA CORRECCIÓN: Pasamos los argumentos requeridos
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProviderRegistrationSuccessPage(
              username: tempUsername,  // Pasamos el email o nombre
              password: tempPassword,  // Pasamos la contraseña generada
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Para que el teclado no tape
      body: Stack(
        children: [
          // CAPA 1: Fondo Blanco
          Container(color: Colors.white),

          // CAPA 2: Degradado con Opacidad
          Opacity(
            opacity: 0.3,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.onboardingGradientStart,
                    AppColors.onboardingGradientEnd,
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
                        color: AppColors.textBlack,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Ya tienes una cuenta ',
                          style: TextStyle(fontSize: 16, color: Color(0xFF667085)),
                        ),
                        GestureDetector(
                          onTap: widget.onSignInClicked ?? () => Navigator.pop(context),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primaryButton,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Stepper Visual
                    _buildStepper(),

                    const SizedBox(height: 40),

                    // Formularios (Envueltos en Form para validación)
                    if (_currentStep == 1)
                      Form(
                        key: _step1FormKey,
                        child: _buildStep1Form(),
                      )
                    else
                      Form(
                        key: _step2FormKey,
                        child: _buildStep2Form(),
                      ),

                    const SizedBox(height: 40),

                    // Botón de Acción
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null // Deshabilita botón si está cargando
                            : () {
                          if (_currentStep == 1) {
                            _onNextPressed();
                          } else {
                            _onSubmitPressed();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryButton,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                            : Text(
                          _currentStep == 1 ? 'Siguiente' : 'Registrar',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿No tienes cuenta? ',
                          style: TextStyle(color: Color(0xFF667085), fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Registrate',
                            style: TextStyle(
                              color: AppColors.primaryButton,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
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

  // --- WIDGETS AUXILIARES ---

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepItem(text: 'Info Personal', number: '1', isActive: _currentStep >= 1),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
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
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: AppColors.primaryButton,
                fontWeight: isActive ? FontWeight.w900 : FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- FORMULARIOS CON VALIDACIÓN ---

  Widget _buildStep1Form() {
    return Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: _buildLabel('Nombres')),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _nameController,
          hintText: 'Ej. Oliver',
          validator: (v) => v!.isEmpty ? 'Ingresa tu nombre' : null,
        ),
        const SizedBox(height: 20),
        Align(alignment: Alignment.centerLeft, child: _buildLabel('Apellido')),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _lastNameController,
          hintText: 'Ej. Smith',
          validator: (v) => v!.isEmpty ? 'Ingresa tu apellido' : null,
        ),
        const SizedBox(height: 20),
        Align(alignment: Alignment.centerLeft, child: _buildLabel('Email')),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _emailController,
          hintText: 'ejemplo@correo.com',
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Requerido';
            if (!v.contains('@')) return 'Email inválido';
            return null;
          },
        ),
        const SizedBox(height: 20),
        Align(alignment: Alignment.centerLeft, child: _buildLabel('Empresa')),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _companyNameController,
          hintText: 'Nombre de tu empresa',
          validator: (v) => v!.isEmpty ? 'Requerido' : null,
        ),
      ],
    );
  }

  Widget _buildStep2Form() {
    return Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: _buildLabel('Calle')),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _streetController,
          hintText: 'Av. Principal',
          validator: (v) => v!.isEmpty ? 'Requerido' : null,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Número'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _numberController,
                    hintText: '123',
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Requerido' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('C. Postal'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _zipCodeController,
                    hintText: '15001',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Align(alignment: Alignment.centerLeft, child: _buildLabel('Ciudad')),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _cityController,
          hintText: 'Lima',
          validator: (v) => v!.isEmpty ? 'Requerido' : null,
        ),
        const SizedBox(height: 20),
        Align(alignment: Alignment.centerLeft, child: _buildLabel('País')),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _countryController,
          hintText: 'Perú',
          validator: (v) => v!.isEmpty ? 'Requerido' : null,
        ),
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
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Color(0xFF475467),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE1E7EF),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 15),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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