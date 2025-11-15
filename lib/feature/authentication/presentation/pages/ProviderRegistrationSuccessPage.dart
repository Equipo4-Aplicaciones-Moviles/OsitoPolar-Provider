import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/RegisterProvider.dart';

class ProviderRegistrationSuccessPage extends StatefulWidget {
  // --- ¡AQUÍ ESTÁ LA CLAVE! ---
  // Este es el parámetro que 'main.dart' espera
  final String? sessionId;

  const ProviderRegistrationSuccessPage({
    super.key,
    required this.sessionId, // <-- 'main.dart' ya no dará error
  });

  @override
  State<ProviderRegistrationSuccessPage> createState() =>
      _ProviderRegistrationSuccessPageState();
}

class _ProviderRegistrationSuccessPageState
    extends State<ProviderRegistrationSuccessPage> {

  bool _didCallProvider = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Llama al provider solo una vez cuando la página se construye
    if (!_didCallProvider) {
      _didCallProvider = true;
      _completeRegistration();
    }
  }

  Future<void> _completeRegistration() async {
    // Lee el provider
    final provider = context.read<RegisterProvider>();

    if (widget.sessionId == null) {
      // Si no hay ID, marca un error (no debería pasar)
      // (Tu provider ya maneja esto, pero podemos forzarlo)
      print("Error: No se recibió sessionId en la página de éxito.");
      await provider.completeRegistration("INVALID_SESSION_ID"); // Llama para forzar el error
      return;
    }

    // --- ¡AQUÍ ES DONDE LLAMAS AL PASO 2! ---
    // Tu RegisterProvider (que ya está perfecto)
    // será llamado con el ID de la URL.
    print("Página de Éxito: Llamando a completeRegistration...");
    await provider.completeRegistration(widget.sessionId!);
  }

  @override
  Widget build(BuildContext context) {
    // Observa los cambios del provider
    final providerState = context.watch<RegisterProvider>().state;
    final errorMessage = context.watch<RegisterProvider>().errorMessage;

    // Maneja la navegación si el estado cambia a completo
    // Usamos un 'listener' para la navegación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (providerState == RegisterState.registrationComplete) {
        // ¡Éxito! Saca al usuario de aquí (ej. al login)
        print("¡Registro completo! Navegando a login.");
        Navigator.of(context).pushNamedAndRemoveUntil('/provider_login', (route) => false);
      }
    });

    return Scaffold(
      body: Center(
        child: (providerState == RegisterState.completingRegistration || providerState == RegisterState.initial)
            ? const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Verificando pago, por favor espera...'),
          ],
        )
            : Padding(
          // Esto se muestra si state == RegisterState.error
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 60),
              const SizedBox(height: 20),
              Text(
                'Error en la Verificación',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Limpia el estado y navega de vuelta al registro para reintentar
                  context.read<RegisterProvider>().resetState();
                  Navigator.of(context).pushNamedAndRemoveUntil('/provider_register', (route) => false);
                },
                child: const Text('Volver al Registro'),
              )
            ],
          ),
        ),
      ),
    );
  }
}