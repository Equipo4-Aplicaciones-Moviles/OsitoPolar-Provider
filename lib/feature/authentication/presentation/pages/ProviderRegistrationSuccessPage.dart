import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para el Clipboard
import 'package:provider/provider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/RegisterProvider.dart';

class ProviderRegistrationSuccessPage extends StatefulWidget {
  final String? sessionId;

  const ProviderRegistrationSuccessPage({
    super.key,
    required this.sessionId,
  });

  @override
  State<ProviderRegistrationSuccessPage> createState() =>
      _ProviderRegistrationSuccessPageState();
}

class _ProviderRegistrationSuccessPageState
    extends State<ProviderRegistrationSuccessPage> {

  @override
  void initState() {
    super.initState();
    // Iniciamos la llamada real al backend tan pronto carga la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callCompleteRegistration();
    });
  }

  Future<void> _callCompleteRegistration() async {
    final provider = context.read<RegisterProvider>();

    if (widget.sessionId == null) {
      // Si no hay ID, dejamos que el provider maneje el error o mostramos algo local
      return;
    }

    // --- ¡LÓGICA REAL ACTIVADA! ---
    await provider.completeRegistration(widget.sessionId!);
  }

  @override
  Widget build(BuildContext context) {
    // Observamos el estado del provider
    final provider = context.watch<RegisterProvider>();
    final state = provider.state;
    final credentials = provider.credentials; // Asegúrate de tener este getter en tu Provider

    // 1. ESTADO: CARGANDO (Mientras llama al backend)
    if (state == RegisterState.completingRegistration || state == RegisterState.initial) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(color: AppColors.primaryButton),
              SizedBox(height: 24),
              Text(
                'Verificando pago y creando cuenta...',
                style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // 2. ESTADO: ERROR (Si el backend falla)
    if (state == RegisterState.error) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 20),
                Text(
                  'Hubo un problema',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  provider.errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Volver al registro para intentar de nuevo
                    Navigator.pushNamedAndRemoveUntil(context, '/provider_register', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryButton),
                  child: const Text('Volver a intentar', style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ),
      );
    }

    // 3. ESTADO: ÉXITO (¡Aquí mostramos la UI Bonita!)
    if (state == RegisterState.registrationComplete && credentials != null) {
      return _buildSuccessUI(context, credentials.username, credentials.password);
    }

    // Fallback por si acaso
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  // --- UI BONITA DE TU AMIGO (Separada para limpieza) ---
  Widget _buildSuccessUI(BuildContext context, String username, String password) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fondo degradado suave
          Opacity(
            opacity: 0.3,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundLight,
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),
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
                          color: Colors.green, // Verde para éxito
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 50),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      '¡Cuenta creada con éxito!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tarjeta de Credenciales
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFD9E2EC)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tus credenciales de acceso',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF102A43),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildCredentialRow(context, icon: Icons.person, label: 'Usuario', value: username),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(color: Colors.black12),
                          ),
                          _buildCredentialRow(context, icon: Icons.lock, label: 'Contraseña (Temporal)', value: password),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Advertencia pequeña
                    const Text(
                      "Por favor, guarda estas credenciales. La contraseña es temporal.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.redAccent, fontSize: 13),
                    ),

                    const SizedBox(height: 40),

                    // Botón Ir al Login
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/provider_login',
                                (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryButton,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          'Iniciar Sesión',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
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
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppColors.primaryButton, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF627D98), fontFamily: 'Inter')),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF102A43),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mono', // Fuente monoespaciada para la contraseña ayuda a leerla
                ),
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
          icon: const Icon(Icons.copy, color: Color(0xFF829AB1)),
        ),
      ],
    );
  }
}