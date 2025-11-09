import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/OsitoPolarFooter.dart';
import '../../../../core/ui/widgets/OsitoPolarTopBar.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/RegisterProvider.dart';
// ---
/// Pantalla de Registro para Providers (Empresas).
/// Pantalla de Registro para Providers (Empresas).
class ProviderRegisterPage extends StatefulWidget {
  // Callbacks para la navegación
  // --- ¡MODIFICADO! El onSignUpClicked ya no es necesario ---
  // final Function(String businessName, String username, String password) onSignUpClicked;
  final VoidCallback onSignInClicked;

  const ProviderRegisterPage({
    super.key,
    // required this.onSignUpClicked,
    required this.onSignInClicked,
  });

  @override
  State<ProviderRegisterPage> createState() => _ProviderRegisterPageState();
}

class _ProviderRegisterPageState extends State<ProviderRegisterPage> {
  // Controladores para los campos de texto
  final _businessNameController = TextEditingController(); // TODO: Tu API solo pide username/password
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
    // --- ¡AÑADIDO! Escuchamos al nuevo provider ---
    final provider = context.watch<RegisterProvider>();
    final state = provider.state;

    // --- ¡AÑADIDO! Listener para navegar ---
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state == RegisterState.success) {
        // Si el registro fue exitoso, volvemos al Login
        // y reseteamos el estado.
        Navigator.pop(context);
        context.read<RegisterProvider>().resetState();
        // TODO: Mostrar un SnackBar de "¡Usuario creado! Inicia sesión."
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
                        isEnabled: state != RegisterState.loading,
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                        controller: _usernameController,
                        labelText: 'Username',
                        isEnabled: state != RegisterState.loading,
                      ),
                      const SizedBox(height: 16.0),
                      _buildPasswordField(
                        controller: _passwordController,
                        labelText: 'Password',
                        isObscured: _obscurePassword,
                        isEnabled: state != RegisterState.loading,
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
                            // Deshabilitado mientras carga
                            onChanged: state == RegisterState.loading
                                ? null
                                : (bool? value) {
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
                        // --- ¡MODIFICADO! ---
                        onPressed: state == RegisterState.loading
                            ? null
                            : () {
                          // TODO: Añadir validación (ej. que contraseñas no estén vacías)
                          // NOTA: Tu API solo pide username/password, no businessName
                          //      ¡Asegúrate de que esto sea correcto!
                          context.read<RegisterProvider>().signUp(
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
                        // --- ¡MODIFICADO! Mostramos spinner ---
                        child: state == RegisterState.loading
                            ? const CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // --- ¡AÑADIDO! Mensaje de Error ---
                      if (state == RegisterState.error)
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
                            onPressed: state == RegisterState.loading ? null : widget.onSignInClicked,
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
    );
  }

  /// Helper para campos de contraseña
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool isObscured,
    required VoidCallback onToggleVisibility,
    bool isEnabled = true, // Añadido
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscured,
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