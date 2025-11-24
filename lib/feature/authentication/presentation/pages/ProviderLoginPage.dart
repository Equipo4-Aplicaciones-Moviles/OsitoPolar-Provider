import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProviderLoginPage extends StatefulWidget {
  final VoidCallback? onRegisterClicked;
  final VoidCallback? onForgotPasswordClicked;

  const ProviderLoginPage({
    super.key,
    this.onRegisterClicked,
    this.onForgotPasswordClicked,
  });

  @override
  State<ProviderLoginPage> createState() => _ProviderLoginPageState();
}

class _ProviderLoginPageState extends State<ProviderLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

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
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // TÍTULO
                    const Text(
                      '¡Bienvenido de vuelta!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textBlack,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // SUBTÍTULO
                    const Text(
                      'Inicia sesion en tu cuenta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF667085),
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 50),

                    // INPUT USUARIO
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildLabel('Nombre de usuario'),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _usernameController,
                      hintText: 'Oliver09',
                    ),

                    const SizedBox(height: 24),

                    // INPUT CONTRASEÑA
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildLabel('Contraseña'),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: '•••••••••',
                      isPassword: true,
                      obscureText: _obscureText,
                      onToggleVisibility: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),

                    // OLVIDASTE CONTRASEÑA
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 8.0),
                        child: TextButton(
                          onPressed: widget.onForgotPasswordClicked,
                          child: const Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              color: AppColors.primaryButton,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // BOTÓN LOGIN
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Lógica
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryButton,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100), // Píldora
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // REGISTRO
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
                          onTap: widget.onRegisterClicked,
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF344054),
        ),
      ),
    );
  }

  // --- WIDGET TEXTFIELD MEJORADO ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Color(0xFF475467),
      ),
      decoration: InputDecoration(
        // COLOR DE FONDO
        filled: true,
        fillColor: const Color(0xFFE1E7EF), // Gris azulado suave

        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 15),

        // --- AQUÍ ARREGLAMOS LA DISTANCIA ---
        // Usamos 20 en lugar de 32. Es suficiente para la curva y no aleja tanto el texto.
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

        // BORDE NORMAL (Sin borde visible o muy sutil)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50), // Píldora
          borderSide: const BorderSide(
            color: Colors.transparent, // Transparente cuando no escribes
            width: 0,
          ),
        ),

        // BORDE AL ESCRIBIR (AZUL)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: AppColors.primaryButton, // Azul al hacer clic
            width: 1.5,
          ),
        ),

        suffixIcon: isPassword
            ? Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: const Color(0xFF475467),
              size: 22,
            ),
            onPressed: onToggleVisibility,
          ),
        )
            : null,
      ),
    );
  }
}