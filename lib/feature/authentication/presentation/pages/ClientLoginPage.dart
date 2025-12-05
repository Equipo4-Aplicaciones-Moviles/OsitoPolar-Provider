import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/OsitoPolarFooter.dart';
import '../../../../core/ui/widgets/OsitoPolarTopBar.dart';

/// Pantalla de Login para Clientes.
/// Es un StatefulWidget para manejar los controladores de texto.
class ClientLoginPage extends StatefulWidget {
  // Callbacks para la navegación
  final Function(String username, String password) onLoginClicked;
  final VoidCallback onRegisterClicked;
  final VoidCallback onForgotPasswordClicked;

  const ClientLoginPage({
    super.key,
    required this.onLoginClicked,
    required this.onRegisterClicked,
    required this.onForgotPasswordClicked,
  });

  @override
  State<ClientLoginPage> createState() => _ClientLoginPageState();
}

class _ClientLoginPageState extends State<ClientLoginPage> {
  // Controladores para leer el texto de los campos
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  // Estado para mostrar/ocultar la contraseña
  bool _obscureText = true;

  // Liberamos los controladores cuando el widget se destruye
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      // 1. Usamos el TopBar reutilizable
      appBar: OsitoPolarTopBar(
        onMenuClicked: () {
          // TODO: Implementar lógica para abrir el drawer (menú lateral)
        },
      ),
      // 2. Usamos el Footer reutilizable
      // Lo ponemos en bottomNavigationBar para que se quede abajo
      bottomNavigationBar: const OsitoPolarFooter(),
      body: SafeArea(
        // Center + SingleChildScrollView para evitar overflow si el teclado aparece
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                // 3. La misma tarjeta que en SelectProfilePage
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
                      // 4. Título "Sign In"
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

                      // 5. Campo de Texto (Username)
                      _buildUsernameField(),
                      const SizedBox(height: 16.0),

                      // 6. Campo de Texto (Password)
                      _buildPasswordField(),
                      const SizedBox(height: 16.0),

                      // 7. Olvidaste tu contraseña
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

                      // 8. Botón de Sign In
                      ElevatedButton(
                        onPressed: () {
                          // Pasamos el texto de los controladores al callback
                          widget.onLoginClicked(
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
                          'Sign In',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // 9. Enlace a Registro
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

  /// Helper Widget para el campo de Username
  Widget _buildUsernameField() {
    return TextField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: 'Username',
        filled: true,
        fillColor: AppColors.textFieldBackground, // Color DCE3EE
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.textFieldBorder, // Color F1
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
            color: AppColors.primaryButton, // Borde Azul al seleccionar
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textColor,
          fontFamily: 'Inter',
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  /// Helper Widget para el campo de Password
  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscureText, // Oculta el texto
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
        // Ícono para mostrar/ocultar contraseña
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textColor,
          ),
          onPressed: () {
            // Actualiza el estado para cambiar el ícono y la visibilidad
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}

//introudce tus cambios aqui