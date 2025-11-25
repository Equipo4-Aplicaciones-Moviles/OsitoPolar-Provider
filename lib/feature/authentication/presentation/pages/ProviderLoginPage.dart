import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:osito_polar_app/core/theme/app_colors.dart';
// Importamos tu Provider y el estado del Login
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';

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
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. ESCUCHAMOS LOS CAMBIOS DE ESTADO
    final provider = context.watch<ProviderLoginProvider>();
    final state = provider.state;
    final bool isLoading = (state == LoginState.loading);

    // 2. LISTENER para navegar al Home si es exitoso
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state == LoginState.success) {
        // Navegamos al home y borramos la pila de navegación
        Navigator.pushNamedAndRemoveUntil(context, '/provider_home', (route) => false);
        // Opcional: Resetear el estado del provider después de navegar
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Capa 1: Fondo Blanco Base
          Container(
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
          ),
          // Capa 2: Degradado suave (TU DISEÑO)
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
                    // Asumiendo que AppColors.onboardingGradientStart/End son los correctos
                    AppColors.backgroundLight,
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),

          // Capa 3: Contenido
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¡Bienvenido de vuelta!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        letterSpacing: -0.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Inicia sesión en tu cuenta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF667085),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 40),

                    // --- MENSAJE DE ERROR ---
                    if (state == LoginState.error)
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          provider.errorMessage,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // --- CAMPO USUARIO ---
                    Align(alignment: Alignment.centerLeft, child: _buildLabel('Nombre de usuario')),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _usernameController,
                      hintText: 'Oliver09',
                      isEnabled: !isLoading,
                    ),

                    const SizedBox(height: 24),

                    // --- CAMPO CONTRASEÑA ---
                    Align(alignment: Alignment.centerLeft, child: _buildLabel('Contraseña')),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: '•••••••••',
                      isPassword: true,
                      obscureText: _obscureText,
                      isEnabled: !isLoading,
                      onToggleVisibility: () {
                        setState(() { _obscureText = !_obscureText; });
                      },
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 8.0),
                        child: TextButton(
                          onPressed: isLoading ? null : widget.onForgotPasswordClicked,
                          child: const Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              color: AppColors.primaryButton,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // --- BOTÓN LOGIN (CONECTADO) ---
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        // 3. LÓGICA DE PRESIONAR: Llama al Provider
                        onPressed: isLoading
                            ? null
                            : () {
                          if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
                            // Validación rápida en UI
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ingresa usuario y contraseña.')),
                            );
                            return;
                          }
                          context.read<ProviderLoginProvider>().signIn(
                            _usernameController.text,
                            _passwordController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryButton,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)), // Diseño píldora
                        ),
                        child: isLoading
                        // 4. MUESTRA SPINNER
                            ? const CircularProgressIndicator(color: Colors.white)
                        // 5. TEXTO NORMAL
                            : const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- FOOTER ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿No tienes cuenta? ', style: TextStyle(color: Color(0xFF667085), fontSize: 14, fontFamily: 'Inter')),
                        GestureDetector(
                            onTap: isLoading ? null : widget.onRegisterClicked,
                            child: const Text('Regístrate', style: TextStyle(color: AppColors.primaryButton, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Inter'))
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF344054), fontFamily: 'Inter'),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    bool obscureText = false,
    bool isEnabled = true,
    VoidCallback? onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      enabled: isEnabled,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF475467), fontFamily: 'Inter'),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE1E7EF),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 15, fontFamily: 'Inter'),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

        // Bordes redondeados estilo "píldora"
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: const BorderSide(color: Colors.transparent, width: 0)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: const BorderSide(color: AppColors.primaryButton, width: 1.5)),

        suffixIcon: isPassword
            ? Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: const Color(0xFF475467), size: 22),
            onPressed: onToggleVisibility,
          ),
        )
            : null,
      ),
    );
  }
}