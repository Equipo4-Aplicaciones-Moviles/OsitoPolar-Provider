import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/app_route.dart';

class ProviderRegistrationSuccessPage extends StatelessWidget {
  // --- AGREGAMOS ESTO PARA QUE MAIN.DART NO DE ERROR ---
  final String? sessionId;

  // Datos hardcodeados para el diseño visual
  final String username = "Oliver";
  final String password = "\$ywrKXKT!JD*Mcos";

  const ProviderRegistrationSuccessPage({
    super.key,
    this.sessionId, // <--- Agregado al constructor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // CAPA 1: Fondo Blanco
          Container(color: Colors.white),

          // CAPA 2: Degradado
          Opacity(
            opacity: 0.3,
            child: Container(
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

          // CAPA 3: Contenido
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // ICONO CHECK
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryButton,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 50,
                        weight: 10,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // TÍTULO
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

                    // TARJETA ADVERTENCIA
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

                    // TARJETA CREDENCIALES
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

                          _buildCredentialRow(
                              context,
                              icon: Icons.person,
                              label: 'Usuario',
                              value: username
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(color: Colors.black12, thickness: 1),
                          ),

                          _buildCredentialRow(
                              context,
                              icon: Icons.lock,
                              label: 'Contraseña',
                              value: password
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // TARJETA PRÓXIMOS PASOS
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
                            '1. Guarda estas credenciales en un lugar seguro.\n'
                                '2. Inicia sesión con tu usuario y contraseña\n'
                                '3. Configura la autenticación de dos factores (2FA)\n'
                                '4. Comienza a gestionar tus equipos',
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

                    // BOTÓN LOGIN
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navegar al Login y limpiar historial
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoute.providerLogin,
                                  (route) => false
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // FOOTER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿No tienes cuenta? ',
                          style: TextStyle(color: Color(0xFF667085), fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {}, // Ya estamos registrados
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
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF667085),
                ),
              ),
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