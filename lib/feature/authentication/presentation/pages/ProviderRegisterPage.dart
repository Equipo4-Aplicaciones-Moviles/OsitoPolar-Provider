import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
// Importamos la página de éxito para poder navegar a ella
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
  // Control de pasos (1 o 2)
  int _currentStep = 1;

  // Controladores Paso 1
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();

  // Controladores Paso 2
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ---------------------------------------------------------
          // CAPA 1: Fondo Blanco Base
          // ---------------------------------------------------------
          Container(
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
          ),

          // ---------------------------------------------------------
          // CAPA 2: Degradado "Linear" al 30% de opacidad
          // ---------------------------------------------------------
          Opacity(
            opacity: 0.3,
            child: Container(
              height: double.infinity,
              width: double.infinity,
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

          // ---------------------------------------------------------
          // CAPA 3: Contenido
          // ---------------------------------------------------------
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // TÍTULO
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

                    // LOGIN LINK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Ya tienes una cuenta ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF667085),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onSignInClicked ?? () => Navigator.pop(context),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primaryButton,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // --- STEPPER ---
                    _buildStepper(),

                    const SizedBox(height: 40),

                    // --- CONTENIDO CAMBIANTE SEGÚN EL PASO ---
                    if (_currentStep == 1)
                      _buildStep1Form()
                    else
                      _buildStep2Form(),

                    const SizedBox(height: 40),

                    // --- BOTÓN DE ACCIÓN ---
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentStep == 1) {
                            // SI ESTOY EN PASO 1 -> IR A PASO 2
                            setState(() {
                              _currentStep = 2;
                            });
                          } else {
                            // SI ESTOY EN PASO 2 -> IR A PANTALLA DE ÉXITO
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProviderRegistrationSuccessPage(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryButton,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Text(
                          _currentStep == 1 ? 'Siguiente' : 'Login',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // FOOTER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿No tienes cuenta? ',
                          style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 14,
                          ),
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

  // --- STEPPER VISUAL ---
  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PASO 1
          _buildStepItem(
              text: 'Información Personal',
              number: '1',
              isActive: _currentStep >= 1
          ),

          // LÍNEA CONECTORA
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
              height: 2,
              color: AppColors.primaryButton,
            ),
          ),

          // PASO 2
          _buildStepItem(
              text: 'Dirección',
              number: '2',
              isActive: _currentStep >= 2
          ),
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
            softWrap: false,
            overflow: TextOverflow.visible,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primaryButton,
              fontWeight: FontWeight.w500,
              height: 1.2,
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

  // --- FORMULARIO PASO 1 ---
  Widget _buildStep1Form() {
    return Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: _buildLabel('Nombres')),
        const SizedBox(height: 8),
        _buildTextField(controller: _nameController, hintText: 'Oliver09'),

        const SizedBox(height: 20),

        Align(alignment: Alignment.centerLeft, child: _buildLabel('Apellido')),
        const SizedBox(height: 8),
        _buildTextField(controller: _lastNameController, hintText: 'Oliver09'),

        const SizedBox(height: 20),

        Align(alignment: Alignment.centerLeft, child: _buildLabel('Email')),
        const SizedBox(height: 8),
        _buildTextField(controller: _emailController, hintText: 'Oliver09'),

        const SizedBox(height: 20),

        Align(alignment: Alignment.centerLeft, child: _buildLabel('Nombre de Empresa')),
        const SizedBox(height: 8),
        _buildTextField(controller: _companyNameController, hintText: 'Oliver09'),
      ],
    );
  }

  // --- FORMULARIO PASO 2 ---
  Widget _buildStep2Form() {
    return Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: _buildLabel('Calle')),
        const SizedBox(height: 8),
        _buildTextField(controller: _streetController, hintText: 'Av. Saturno'),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Número'),
                  const SizedBox(height: 8),
                  _buildTextField(controller: _numberController, hintText: '14'),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Código postal'),
                  const SizedBox(height: 8),
                  _buildTextField(controller: _zipCodeController, hintText: '15621'),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Align(alignment: Alignment.centerLeft, child: _buildLabel('Ciudad')),
        const SizedBox(height: 8),
        _buildTextField(controller: _cityController, hintText: 'Lima'),

        const SizedBox(height: 20),

        Align(alignment: Alignment.centerLeft, child: _buildLabel('País')),
        const SizedBox(height: 8),
        _buildTextField(controller: _countryController, hintText: 'Lima'),
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
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Color(0xFF475467),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE1E7EF), // Gris azulado suave
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 15),

        // Padding interno ajustado
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: AppColors.primaryButton, width: 1.5),
        ),
      ),
    );
  }
}