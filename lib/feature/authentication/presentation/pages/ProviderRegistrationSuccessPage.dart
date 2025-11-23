import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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


    WidgetsBinding.instance.addPostFrameCallback((_) {
      _completeRegistration();
    });
  }

  Future<void> _completeRegistration() async {

    final provider = context.read<RegisterProvider>();

    if (widget.sessionId == null) {
      print("Página de Éxito: No se recibió sessionId. Mostrando error.");

      await provider.completeRegistration("INVALID_SESSION_ID_FROM_UI");
      return;
    }

    try {

      print("Página de Éxito: Llamando a completeRegistration con ${widget.sessionId}");
      await provider.completeRegistration(widget.sessionId!);

    } catch (e) {

      print("Error inesperado en _completeRegistration: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    final providerState = context.watch<RegisterProvider>().state;
    final errorMessage = context.watch<RegisterProvider>().errorMessage;


    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (providerState == RegisterState.registrationComplete) {
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