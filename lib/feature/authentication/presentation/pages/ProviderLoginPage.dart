import 'package:flutter/material.dart';
// 1. Ya no necesitamos importar el Provider, ¡lo hemos desconectado!
// import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';
// import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
// (Asumiendo que tus widgets core SÍ usan 'PascalCase.dart' como tus otras carpetas)
import '../../../../core/ui/widgets/OsitoPolarFooter.dart';
import '../../../../core/ui/widgets/OsitoPolarTopBar.dart';

/// Pantalla de Login para Providers (Empresas).
class ProviderLoginPage extends StatefulWidget {
  // 2. Quitamos el 'onLoginClicked' porque lo manejamos aquí
  final VoidCallback onRegisterClicked;
  final VoidCallback onForgotPasswordClicked;

  const ProviderLoginPage({
    super.key,
    required this.onRegisterClicked,
    required this.onForgotPasswordClicked,
  });

  @override
  State<ProviderLoginPage> createState() => _ProviderLoginPageState();
}

class _ProviderLoginPageState extends State<ProviderLoginPage> {
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
    // 3. ¡BORRAMOS TODA LA LÓGICA DEL PROVIDER!
    //    Ya no usamos context.watch, state, ni el listener.
    //    Esto evita cualquier error de 'GetIt' o de 'state'.

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: OsitoPolarTopBar(
        onMenuClicked: () {},
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
                        isEnabled: true, // Siempre habilitado
                      ),
                      const SizedBox(height: 16.0),

                      // --- CAMPO "PASSWORD" ---
                      _buildPasswordField(
                        isEnabled: true, // Siempre habilitado
                      ),
                      const SizedBox(height: 16.0),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: widget.onForgotPasswordClicked, // Siempre habilitado
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

                      // --- 4. ¡AQUÍ ESTÁ EL BYPASS! ---
                      ElevatedButton(
                        onPressed: () {
                          print('--- LOGIN SIMULADO (BYPASS) ---');
                          // Navegamos directamente al home sin verificar.
                          // Esto funciona porque ya descomentamos la ruta en main.dart
                          Navigator.pushReplacementNamed(context, '/provider_home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryButton,
                          foregroundColor: AppColors.buttonLabel,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        // 5. Ya no mostramos el Spinner, solo el texto
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // 6. Ya no mostramos el mensaje de error
                      const SizedBox(height: 16.0),

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
                            onPressed: widget.onRegisterClicked, // Siempre habilitado
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

  // ... (Los helpers _buildTextField y _buildPasswordField no cambian) ...
  /// Helper para campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
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
  Widget _buildPasswordField({bool isEnabled = true}) {
    return TextField(
      controller: _passwordController,
      obscureText: _obscureText,
      enabled: isEnabled,
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