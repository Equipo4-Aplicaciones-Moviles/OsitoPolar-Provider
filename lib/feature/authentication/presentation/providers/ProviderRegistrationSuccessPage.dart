import 'package:flutter/material.dart';
// ... tus otros imports ...

class ProviderRegistrationSuccessPage extends StatefulWidget {
  // --- NUEVO: El ID que recibimos de main.dart ---
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

  bool _isCompleting = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Inicia el Paso 2 de la registración
    _completeRegistration();
  }

  Future<void> _completeRegistration() async {
    if (widget.sessionId == null) {
      setState(() {
        _isCompleting = false;
        _errorMessage = 'Error: No se recibió el ID de la sesión.';
      });
      return;
    }

    try {
      // --- ESTA ES LA LLAMADA FINAL A TU BACKEND ---
      // final provider = context.read<RegisterProvider>();
      // await provider.completeRegistration(widget.sessionId!);

      // ¡Simula un éxito por ahora!
      await Future.delayed(const Duration(seconds: 2));

      // Si todo sale bien, manda al usuario al login (o al home)
      Navigator.of(context).pushNamedAndRemoveUntil('/provider_login', (route) => false);

    } catch (e) {
      setState(() {
        _isCompleting = false;
        _errorMessage = 'Hubo un error al finalizar tu registro: $e';
      });
    }
  }

  // ... (El resto de tu widget 'build' con el spinner y el error) ...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isCompleting
            ? Column(
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
              Icon(Icons.error, color: Colors.red, size: 60),
              SizedBox(height: 20),
              Text(
                'Error en la Verificación',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 10),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}