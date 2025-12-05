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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Icono Check Azul
              Container(
                width: 80, height: 80,
                decoration: const BoxDecoration(color: AppColors.primaryButton, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 50),
              ),
              const SizedBox(height: 24),

              const Text(
                "¡Tu cuenta ha sido creada!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Caja de Advertencia (Rojo Suave)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFADBD8), // Rojo muy suave
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Color(0xFFC0392B)),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Importante: Estas credenciales se muestran solo una vez. Guárdalas en un lugar seguro.",
                        style: TextStyle(fontSize: 12, color: Color(0xFF922B21)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Caja de Credenciales (Gris)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tus credenciales de acceso", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 20),

                    // Usuario
                    _buildCopyRow(Icons.person, "Usuario", username),
                    const Divider(height: 30),
                    // Password
                    _buildCopyRow(Icons.lock, "Contraseña", password),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Caja de Próximos Pasos (Morado/Lila suave según tu imagen)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8DAEF), // Lila suave
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Próximos pasos:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5B2C6F))),
                    SizedBox(height: 8),
                    Text("1. Guarda estas credenciales.\n2. Inicia sesión con tu usuario.\n3. Configura la autenticación 2FA.\n4. Comienza a gestionar tus equipos.",
                        style: TextStyle(fontSize: 12, color: Color(0xFF4A235A), height: 1.5)),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Ir al Login
                    Navigator.pushNamedAndRemoveUntil(context, '/provider_login', (r) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryButton,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Continuar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 16),
              const Text("¿No tienes cuenta? Regístrate", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCopyRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryButton, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'monospace')),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, size: 20, color: Colors.black54),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copiado!")));
          },
        )
      ],
    );
  }
}