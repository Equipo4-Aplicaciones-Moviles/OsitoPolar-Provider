import 'package:flutter/material.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';
// --- 1. ¡ESTA ES LA LÍNEA CORREGIDA! ---
//    Cambiamos el 'import' para que coincida con tu 'main.dart' y 'ServiceLocator.dart'
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
// (Asumiendo que tus widgets core SÍ usan 'PascalCase.dart' como tus otras carpetas)
import '../../../../core/ui/widgets/OsitoPolarFooter.dart';
import '../../../../core/ui/widgets/OsitoPolarTopBar.dart';

/// Pantalla de Login para Providers (Empresas).
/// Pantalla de Login para Providers (Empresas).
class ProviderLoginPage extends StatefulWidget {
  // 2. ¡YA NO NECESITAMOS 'onLoginClicked'!
  //    La pantalla ahora maneja su propia lógica.
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
    // 3. ESCUCHAMOS LOS CAMBIOS DE ESTADO
    //    Usamos 'watch' y el nombre de tu CLASE 'ProviderLoginProvider'
    final provider = context.watch<ProviderLoginProvider>();
    final state = provider.state;

    // 4. ESCUCHAMOS "EVENTOS" (como éxito en login para navegar)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state == LoginState.success) {
        // Si el login fue exitoso, navegamos al home
        Navigator.pushReplacementNamed(context, '/provider_home');
        // TODO: Resetear el estado en el provider (provider.resetState())
      }
    });

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
                        // Deshabilitamos el campo si está cargando
                        isEnabled: state != LoginState.loading,
                      ),
                      const SizedBox(height: 16.0),

                      // --- CAMPO "PASSWORD" ---
                      _buildPasswordField(
                        isEnabled: state != LoginState.loading,
                      ),
                      const SizedBox(height: 16.0),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          // Deshabilitamos si está cargando
                          onPressed: state == LoginState.loading
                              ? null
                              : widget.onForgotPasswordClicked,
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

                      // --- BOTÓN "SIGN IN" (MODIFICADO) ---
                      ElevatedButton(
                        // 5. LLAMAMOS AL PROVIDER
                        onPressed: state == LoginState.loading
                            ? null
                            : () {
                          // Usamos el nombre de tu CLASE 'ProviderLoginProvider'
                          context.read<ProviderLoginProvider>().signIn(
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
                        // 6. MOSTRAMOS SPINNER SI ESTÁ CARGANDO
                        child: state == LoginState.loading
                            ? const CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : const Text(
                          'Sign In',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // 7. MOSTRAMOS MENSAJE DE ERROR
                      if (state == LoginState.error)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            provider.errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),

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
                            // Deshabilitamos si está cargando
                            onPressed: state == LoginState.loading
                                ? null
                                : widget.onRegisterClicked,
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
    bool isEnabled = true, // Añadido
  }) {
    return TextField(
      controller: controller,
      enabled: isEnabled, // Aplicado
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
  Widget _buildPasswordField({bool isEnabled = true}) { // Añadido
    return TextField(
      controller: _passwordController,
      obscureText: _obscureText,
      enabled: isEnabled, // Aplicado
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