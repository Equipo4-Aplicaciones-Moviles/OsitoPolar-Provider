import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/OsitoPolarFooter.dart';
import '../../../../core/ui/widgets/OsitoPolarTopBar.dart';

/// Pantalla de Registro para Providers (Empresas).
class ProviderRegisterPage extends StatefulWidget {
  // Callbacks para la navegación
  final Function(String businessName, String username, String password)
  onSignUpClicked;
  final VoidCallback onSignInClicked;

  const ProviderRegisterPage({
    super.key,
    required this.onSignUpClicked,
    required this.onSignInClicked,
  });

  @override
  State<ProviderRegisterPage> createState() => _ProviderRegisterPageState();
}

class _ProviderRegisterPageState extends State<ProviderRegisterPage> {
  // Controladores para los campos de texto
  final _businessNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: OsitoPolarTopBar(
        onMenuClicked: () {
          // TODO: Implementar lógica del drawer
        },
      ),
      bottomNavigationBar: const OsitoPolarFooter(),
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
                  side: const BorderSide(
                    color: AppColors.cardBorder,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 48.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Register',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.title,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // --- CAMPOS DE TEXTO ---
                      _buildTextField(
                        controller: _businessNameController,
                        labelText: 'Business name',
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                        controller: _usernameController,
                        labelText: 'Username',
                      ),
                      const SizedBox(height: 16.0),
                      _buildPasswordField(
                        controller: _passwordController,
                        labelText: 'Password',
                        isObscured: _obscurePassword,
                        onToggleVisibility: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),

                      // --- CHECKBOX ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (bool? value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: AppColors.primaryButton,
                            checkColor: AppColors.buttonLabel,
                            side: const BorderSide(
                              color: AppColors.textColor,
                              width: 1.5,
                            ),
                          ),
                          const Text(
                            'Remember Me',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),

                      // --- BOTÓN "SIGN UP" ---
                      ElevatedButton(
                        onPressed: () {
                          widget.onSignUpClicked(
                            _businessNameController.text,
                            _usernameController.text,
                            _passwordController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryButton,
                          foregroundColor: AppColors.buttonLabel,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // --- ENLACE A "SIGN IN" ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontFamily: 'Inter',
                            ),
                          ),
                          TextButton(
                            onPressed: widget.onSignInClicked,
                            child: const Text(
                              'Login', // El diseño dice 'Login'
                              style: TextStyle(
                                color: AppColors.textLink,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
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

  /// Helper para campos de texto normales
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: AppColors.textFieldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.textFieldBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.textFieldBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.primaryButton,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textColor,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  /// Helper para campos de contraseña
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool isObscured,
    required VoidCallback onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscured,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: AppColors.textFieldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.textFieldBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.textFieldBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.primaryButton,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textColor,
          fontFamily: 'Inter',
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textColor,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }
}
