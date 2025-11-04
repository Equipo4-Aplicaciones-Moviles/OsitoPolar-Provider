import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
// Importa TODAS las pantallas que vamos a conectar
import 'package:osito_polar_app/feature/authentication/presentation/pages/SelectProfilePage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ClientLoginPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ClientRegisterPage.dart';

import 'feature/authentication/presentation/pages/ProviderLoginPage.dart';
import 'feature/authentication/presentation/pages/ProviderRegisterPage.dart';
// TODO: Importa las pantallas de Provider cuando las tengas
// import 'package:osito_polar_app/features/authentication/presentation/pages/provider_login_page.dart';

void main() {
  // Aquí puedes configurar tu Service Locator (get_it) si lo usas
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

      // 1. Ya no usamos 'home', definimos la ruta inicial
      initialRoute: '/select_profile',

      // 2. Definimos el "mapa" de navegación de la app
      routes: {
        // --- RUTA INICIAL ---
        '/select_profile': (context) => SelectProfilePage(
          // Aquí es donde solucionamos el error:
          // Le decimos qué hacer a cada botón
          onClientClicked: () {
            // Navega a la ruta '/client_login'
            Navigator.pushNamed(context, '/client_login');
          },
          onProviderClicked: () {
            // TODO: Navegar a '/provider_login' cuando exista
            // Por ahora, navega a la de cliente como ejemplo
            Navigator.pushNamed(context, '/provider_login');
          },
        ),

        // --- RUTAS DE AUTENTICACIÓN DE CLIENTE ---
        '/client_login': (context) => ClientLoginPage(
          onLoginClicked: (username, password) {
            // TODO: Aquí va tu lógica de Login (Provider/ViewModel)
            // Si el login es exitoso, navegas al Home del cliente
            // Navigator.pushReplacementNamed(context, '/client_home');
          },
          onRegisterClicked: () {
            // Navega a la pantalla de registro
            Navigator.pushNamed(context, '/client_register');
          },
          onForgotPasswordClicked: () {
            // TODO: Navegar a la pantalla de 'forgot_password'
          },
        ),

        '/client_register': (context) => ClientRegisterPage(
          onSignUpClicked: (username, password) {
            // TODO: Aquí va tu lógica de Registro (Provider/ViewModel)
            // Después de registrarse, volvemos a la pantalla de Login
            Navigator.pop(context);

            // Opcional: puedes mostrar un SnackBar de "Registro exitoso"
          },
          onSignInClicked: () {
            // Si ya tiene cuenta, vuelve a la pantalla anterior (Login)
            Navigator.pop(context);
          },
        ),

        // TODO: Añadir las rutas para Provider

        // --- RUTAS DE AUTENTICACIÓN DE Provider ---
        '/provider_login': (context) => ProviderLoginPage(
          onLoginClicked: (username, password) {
            // TODO: Aquí va tu lógica de Login (Provider/ViewModel)
            // Si el login es exitoso, navegas al Home del cliente
            // Navigator.pushReplacementNamed(context, '/client_home');
          },
          onRegisterClicked: () {
            // Navega a la pantalla de registro
            Navigator.pushNamed(context, '/client_register');
          },
          onForgotPasswordClicked: () {
            // TODO: Navegar a la pantalla de 'forgot_password'
          },
        ),

        '/provider_register': (context) => ProviderRegisterPage(
          onSignUpClicked: (businessName,username, password) {
            // TODO: Aquí va tu lógica de Registro (Provider/ViewModel)
            // Después de registrarse, volvemos a la pantalla de Login
            Navigator.pop(context);

            // Opcional: puedes mostrar un SnackBar de "Registro exitoso"
          },
          onSignInClicked: () {
            // Si ya tiene cuenta, vuelve a la pantalla anterior (Login)
            Navigator.pop(context);
          },
        ),

        // '/provider_login': (context) => ...
        // '/provider_register': (context) => ...
      },
    );
  }
}
