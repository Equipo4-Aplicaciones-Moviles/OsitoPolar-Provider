import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';

// --- IMPORTACIONES DE AUTENTICACIÓN COMENTADAS ---
// Ya que no existen en esta rama, las comentamos para que la app compile.
/*
import 'package:osito_polar_app/features/authentication/presentation/pages/select_profile_page.dart';
import 'package:osito_polar_app/features/authentication/presentation/pages/client_login_page.dart';
import 'package:osito_polar_app/features/authentication/presentation/pages/client_register_page.dart';
import 'package:osito_polar_app/features/authentication/presentation/pages/provider_login_page.dart';
import 'package:osito_polar_app/features/authentication/presentation/pages/provider_register_page.dart';
*/

// --- ¡IMPORTACIONES DEL PROVIDER DASHBOARD (ESTAS SÍ EXISTEN)! ---
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderHomePage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderClientAccountPage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderEquipmentDetailPage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderClientsTechniciansPage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OsitoPolar App',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryButton,
          onPrimary: AppColors.buttonLabel,
          secondary: AppColors.title,
          background: AppColors.backgroundLight,
          surface: AppColors.cardBackground,
          onSurface: AppColors.textColor,
          outline: AppColors.textFieldBorder,
          surfaceVariant: AppColors.cardBorder,
        ),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),

      // 1. --- RUTA INICIAL MODIFICADA ---
      // Hacemos que la app inicie directamente en el home del provider,
      // ya que es lo único que tenemos en esta rama.
      initialRoute: '/provider_home',

      // 2. Definimos el "mapa" de navegación de la app
      routes: {
        // --- RUTAS DE AUTENTICACIÓN COMENTADAS ---
        /*
        '/select_profile': (context) => SelectProfilePage(
              onClientClicked: () {
                Navigator.pushNamed(context, '/client_login');
              },
              onProviderClicked: () {
                Navigator.pushNamed(context, '/provider_login');
              },
            ),
        '/client_login': (context) => ClientLoginPage(
              onLoginClicked: (username, password) {
                // TODO: Lógica de Login (Provider/ViewModel)
                // Navigator.pushReplacementNamed(context, '/client_home');
              },
              onRegisterClicked: () {
                Navigator.pushNamed(context, '/client_register');
              },
              onForgotPasswordClicked: () {
                // TODO: Navegar a 'forgot_password'
              },
            ),
        '/client_register': (context) => ClientRegisterPage(
              onSignUpClicked: (username, password) {
                // TODO: Lógica de Registro (Provider/ViewModel)
                Navigator.pop(context);
              },
              onSignInClicked: () {
                Navigator.pop(context);
              },
            ),
        '/provider_login': (context) => ProviderLoginPage(
              onLoginClicked: (businessName, password) {
                Navigator.pushReplacementNamed(context, '/provider_home');
              },
              onRegisterClicked: () {
                Navigator.pushNamed(context, '/provider_register');
              },
              onForgotPasswordClicked: () {
                // TODO: Navegar a 'provider_forgot_password'
              },
            ),
        '/provider_register': (context) => ProviderRegisterPage(
              onSignUpClicked: (businessName, username, password) {
                Navigator.pop(context);
              },
              onSignInClicked: () {
                Navigator.pop(context);
              },
            ),
        */

        // --- RUTAS DEL DASHBOARD DEL PROVIDER (ESTAS SÍ FUNCIONAN) ---
        '/provider_home': (context) => const ProviderHomePage(),
        '/provider_equipment_detail': (context) =>
        const ProviderEquipmentDetailPage(),
        '/provider_clients_technicians': (context) =>
        const ProviderClientsTechniciansPage(),
        '/provider_client_account': (context) =>
        const ProviderClientAccountPage(),

        // --- RUTAS DE CLIENTE COMENTADAS ---
        // TODO: Añadir las rutas del dashboard del cliente aquí
        // '/client_home': (context) => const ClientHomePage(),
      },
    );
  }
}