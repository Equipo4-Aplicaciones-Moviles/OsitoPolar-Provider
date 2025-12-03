import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';

class TwoFactorVerificationPage extends StatefulWidget {
  const TwoFactorVerificationPage({super.key});

  @override
  State<TwoFactorVerificationPage> createState() => _TwoFactorVerificationPageState();
}

class _TwoFactorVerificationPageState extends State<TwoFactorVerificationPage> {
  // Controladores para 6 dígitos
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    // Mover foco al siguiente campo si se escribe un número
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    // Mover foco al anterior si se borra
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Verificar si el código está completo
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      _verifyCode();
    }
  }

  void _verifyCode() {
    final code = _controllers.map((c) => c.text).join();
    context.read<ProviderLoginProvider>().verifyTwoFactor(code);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProviderLoginProvider>();
    final isLoading = provider.state == LoginState.loading;

    // Escuchar éxito para navegar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.state == LoginState.success) {
        Navigator.pushNamedAndRemoveUntil(context, '/provider_home', (route) => false);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- LOGO OSITO POLAR ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryButton.withOpacity(0.1),
              ),
              child: const Icon(
                  Icons.ac_unit_rounded, // Icono representativo del frío/polar
                  size: 60,
                  color: AppColors.primaryButton
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "OsitoPolar",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryButton,
                  fontFamily: 'Inter'
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              "Verificación de Seguridad",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter'
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Ingresa el código de 6 dígitos generado por tu aplicación autenticadora.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 40),

            // --- INPUT DE CÓDIGO (PIN) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  height: 55,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    onChanged: (val) => _onCodeChanged(val, index),
                    decoration: InputDecoration(
                      counterText: "",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primaryButton, width: 2),
                      ),
                      fillColor: const Color(0xFFF5F7FA),
                      filled: true,
                    ),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),

            // Mensaje de Error
            if (provider.state == LoginState.error)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  provider.errorMessage,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

            // Botón Verificar
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : _verifyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryButton,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Verificar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}