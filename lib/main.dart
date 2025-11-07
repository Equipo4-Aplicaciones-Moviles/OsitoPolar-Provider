import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/core/di/ServiceLocator.dart'; // <-- Tus 'PascalCase'
import 'package:provider/provider.dart';

// --- 1. USANDO TUS NOMBRES DE ARCHIVO 'PascalCase.dart' ---
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/SelectProfilePage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ClientLoginPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ClientRegisterPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderLoginPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderRegisterPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator(); // Llama a tu 'ServiceLocator.dart'

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          // 2. USANDO TU NOMBRE DE CLASE 'ProviderLoginProvider'
          create: (_) => sl<ProviderLoginProvider>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OsitoPolar App',
      debugShowCheckedModeBanner: false, // 🔥 Quita el banner de DEBUG
      theme: ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      initialRoute: '/select_profile',
      routes: {
        '/select_profile': (context) => SelectProfilePage(
              onClientClicked: () {
                Navigator.pushNamed(context, '/client_login');
              },
              onProviderClicked: () {
                Navigator.pushNamed(context, '/provider_login');
              },
            ),
        '/client_login': (context) => ClientLoginPage(
              onLoginClicked: (username, password) {},
              onRegisterClicked: () {
                Navigator.pushNamed(context, '/client_register');
              },
              onForgotPasswordClicked: () {},
            ),
        '/client_register': (context) => ClientRegisterPage(
              onSignUpClicked: (username, password) {
                Navigator.pop(context);
              },
              onSignInClicked: () {
                Navigator.pop(context);
              },
            ),
        '/provider_login': (context) => ProviderLoginPage(
              onRegisterClicked: () {
                Navigator.pushNamed(context, '/provider_register');
              },
              onForgotPasswordClicked: () {},
            ),
        '/provider_register': (context) => ProviderRegisterPage(
              onSignUpClicked: (businessName, username, password) {
                Navigator.pop(context);
              },
              onSignInClicked: () {
                Navigator.pop(context);
              },
            ),
      },
    );
  }
}
