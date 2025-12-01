import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';

class TwoFactorSetupPage extends StatefulWidget {
  const TwoFactorSetupPage({super.key});

  @override
  State<TwoFactorSetupPage> createState() => _TwoFactorSetupPageState();
}

class _TwoFactorSetupPageState extends State<TwoFactorSetupPage> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProviderLoginProvider>();

    // Decodificamos la imagen Base64 del QR
    // La API manda "data:image/png;base64,AAAA...", hay que quitar el prefijo
    final String? rawQr = provider.tempQrCode;
    Uint8List? qrBytes;
    if (rawQr != null) {
      try {
        final base64String = rawQr.split(',').last; // Quita "data:image/..."
        qrBytes = base64Decode(base64String);
      } catch (e) {
        print("Error decodificando QR: $e");
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Configura 2FA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Asegura tu cuenta. Necesitarás una app como Google Authenticator o Authy.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),

            const Text("1. Escanea este código QR", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // IMAGEN QR
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryButton, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: qrBytes != null
                  ? Image.memory(qrBytes, width: 180, height: 180, fit: BoxFit.cover)
                  : const SizedBox(width: 180, height: 180, child: Center(child: Text("Error cargando QR"))),
            ),

            const SizedBox(height: 30),
            const Text("O ingresa la clave manualmente", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // CLAVE MANUAL (Botón Copiar)
            GestureDetector(
              onTap: () {
                if (provider.tempSecret != null) {
                  Clipboard.setData(ClipboardData(text: provider.tempSecret!));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Clave copiada!")));
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E7EF),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      provider.tempSecret ?? "No disponible",
                      style: const TextStyle(fontFamily: 'Monospace', fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.copy, size: 18, color: Colors.black54),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
            const Text("2. Ingresa el código de 6 dígitos", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // INPUT CÓDIGO
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 5, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: "000000",
                counterText: "",
                filled: true,
                fillColor: const Color(0xFFE1E7EF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            if (provider.state == LoginState.error)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(provider.errorMessage, style: const TextStyle(color: Colors.red)),
              ),

            // BOTÓN ACTIVAR
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: provider.state == LoginState.loading
                    ? null
                    : () {
                  if (_codeController.text.length == 6) {
                    provider.verifyTwoFactor(_codeController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryButton,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: provider.state == LoginState.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Activar y continuar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}