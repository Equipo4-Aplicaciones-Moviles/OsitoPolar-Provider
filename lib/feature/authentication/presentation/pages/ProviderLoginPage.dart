import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/OsitoPolarFooter.dart';
import '../../../../core/ui/widgets/OsitoPolarTopBar.dart';

/// Pantalla de Login para Providers (Empresas).
class ProviderLoginPage extends StatefulWidget {
  // Callbacks para la navegación
  final Function(String businessName, String password) onLoginClicked;
  final VoidCallback onRegisterClicked;
  final VoidCallback onForgotPasswordClicked;

  const ProviderLoginPage({
    super.key,
    required this.onLoginClicked,
    required this.onRegisterClicked,
    required this.onForgotPasswordClicked,
  });

  @override
  State<ProviderLoginPage> createState() => _ProviderLoginPageState();
}

class _ProviderLoginPageState extends State<ProviderLoginPage> {
  // Controladores para leer el texto de los campos
  final _businessNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _businessNameController.dispose();
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
                        'Sign In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.title,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // --- CAMPO "EMPRESA" ---
                      _buildTextField(
                        controller: _businessNameController,
                        labelText: 'Empresa',
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 16.0),

                      // --- CAMPO "PASSWORD" ---
                      _buildPasswordField(),
                      const SizedBox(height: 16.0),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: widget.onForgotPasswordClicked,
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.textLink,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // --- BOTÓN "SIGN IN" ---
                      ElevatedButton(
                        onPressed: () {
                          widget.onLoginClicked(
                            _businessNameController.text,
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
                          'Sign In',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // --- ENLACE A REGISTRO ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontFamily: 'Inter',
                            ),
                          ),
                          TextButton(
                            onPressed: widget.onRegisterClicked,
                            child: const Text(
                              'Register',
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

  /// Helper para campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
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
      keyboardType: keyboardType,
    );
  }

  /// Helper para el campo de Password
  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
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
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textColor,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
