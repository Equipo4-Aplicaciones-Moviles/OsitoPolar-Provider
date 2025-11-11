import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/RegisterProvider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';

class ProviderRegistrationSuccessPage extends StatefulWidget {
  const ProviderRegistrationSuccessPage({super.key});

  @override
  State<ProviderRegistrationSuccessPage> createState() =>
      _ProviderRegistrationSuccessPageState();
}

class _ProviderRegistrationSuccessPageState
    extends State<ProviderRegistrationSuccessPage> {

  // Ya no necesitamos la bandera '_isProcessing'
  // porque initState() solo se ejecuta una vez.

  @override
  void initState() {
    super.initState();

    // --- ¡AQUÍ ESTÁ LA MAGIA! ---
    // Programamos el trabajo para que se ejecute DESPUÉS de que
    // la primera compilación (build) esté completa.
    WidgetsBinding.instance.addPostFrameCallback((_) {

      // Ahora es seguro usar 'context'
      final provider = context.read<RegisterProvider>();

      // Obtenemos el 'session_id' de la URL
      final Uri uri = Uri.base;
      String? sessionId;

      // Los parámetros de la URL están DENTRO del fragmento hash
      if (uri.fragment.contains('?')) {
        // El fragmento es: /registration/success?session_id=cs_test_...
        final fragmentParts = uri.fragment.split('?');

        // fragmentParts[0] es '/registration/success'
        // fragmentParts[1] es 'session_id=cs_test_...'
        if (fragmentParts.length > 1) {
          // Parseamos la cadena de query
          final queryParams = Uri.splitQueryString(fragmentParts[1]);
          sessionId = queryParams['session_id'];
        }
      }

      if (sessionId == null || sessionId.isEmpty) {
        // Error: No hay ID de sesión
        provider.resetState(); // Limpia todo
        Navigator.pushReplacementNamed(context, '/provider_register');
        // (Opcional: muestra un SnackBar de error)
      } else {
        // ¡Tenemos el ID! Le decimos al provider que complete el registro
        print("Página de Éxito: Completando registro con sessionId: $sessionId");
        provider.completeRegistration(sessionId);
      }
    });
  }

  // ¡Borramos el método didChangeDependencies() por completo!

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegisterProvider>();
    final state = provider.state;

    Widget content;

    switch (state) {
      case RegisterState.completingRegistration:
        content = const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 24),
            Text('Verificando pago y creando cuenta...',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
          ],
        );
        break;
      case RegisterState.registrationComplete:
        content = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
            const SizedBox(height: 24),
            const Text('¡Registro Exitoso!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Tu cuenta ha sido creada. Ya puedes iniciar sesión.',
                textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                provider.resetState();
                Navigator.pushReplacementNamed(context, '/provider_login');
              },
              child: const Text('Ir a Iniciar Sesión'),
            ),
          ],
        );
        break;
      case RegisterState.error:
        content = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 80),
            const SizedBox(height: 24),
            const Text('¡Error en el Registro!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(provider.errorMessage, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                provider.resetState();
                Navigator.pushReplacementNamed(context, '/provider_register');
              },
              child: const Text('Volver a Intentar'),
            ),
          ],
        );
        break;
      default:
      // Estado 'initial' o 'creatingCheckout' (no debería pasar aquí)
      // Mostramos un spinner mientras esperamos que el initState termine
        content = const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: content,
          ),
        ),
      ),
    );
  }
}