import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/app_route.dart';

class ProviderRegistrationSuccessPage extends StatelessWidget {
  final String? sessionId;

  // ---------------------------------------------------------
  // LÓGICA AGREGADA: Variables finales (sin datos fijos)
  // ---------------------------------------------------------
  final String username;
  final String password;

  const ProviderRegistrationSuccessPage({
    super.key,
    this.sessionId,
    // LÓGICA AGREGADA: Pedimos los datos obligatoriamente
    required this.username,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Capa 1: Fondo Blanco
          Container(color: Colors.white),

          // Capa 2: Degradado
          Opacity(
            opacity: 0.3,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.onboardingGradientStart,
                    AppColors.onboardingGradientEnd
                  ],
                ),
              ),
            ),
          ),

          // Capa 3: Contenido
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icono Check
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryButton,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 50, weight: 10),
                    ),
                    const SizedBox(height: 24),

                    // Título
                    const Text(
                      '¡Tu cuenta ha sido creada !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textBlack,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tarjeta Advertencia (Rojo suave)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFA9A9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Color(0xFF8B2D2D), size: 30),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Importante: Estas credenciales se muestran solo una vez. Guardalas en un lugar seguro.',
                              style: TextStyle(
                                color: const Color(0xFF5A1A1A).withOpacity(0.8),
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tarjeta Credenciales (Gris azulado)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDEE4ED),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tus credenciales de acceso',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textBlack,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Usamos la variable 'username' real
                          _buildCredentialRow(context, icon: Icons.person, label: 'Usuario', value: username),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(color: Colors.black12, thickness: 1),
                          ),

                          // Usamos la variable 'password' real
                          _buildCredentialRow(context, icon: Icons.lock, label: 'Contraseña', value: password),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tarjeta Próximos Pasos (Lila suave)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8C7D9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Próximos pasos:',
                            style: TextStyle(fontSize: 14, color: Color(0xFF4A4A4A)),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '1. Guarda estas credenciales en un lugar seguro.\n2. Inicia sesión con tu usuario y contraseña\n3. Configura la autenticación de dos factores (2FA)\n4. Comienza a gestionar tus equipos',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A4A4A),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Botón Login
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoute.providerLogin,
                                (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryButton,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

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

  Widget _buildCredentialRow(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryButton, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copiado al portapapeles'), duration: Duration(seconds: 1)),
            );
          },
          icon: const Icon(Icons.content_copy_rounded, color: Colors.black54),
        ),
      ],
    );
  }
}