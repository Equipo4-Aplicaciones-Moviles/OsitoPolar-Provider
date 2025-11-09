import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/core/di/ServiceLocator.dart';
import 'package:provider/provider.dart';

// --- Providers ---
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';
// ¡NUEVO! Importamos el Provider del Home
import 'package:osito_polar_app/feature/provider-dashboard/presentation/providers/ProviderHomeProvider.dart';

// --- Páginas ---
import 'package:osito_polar_app/feature/authentication/presentation/pages/SelectProfilePage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ClientLoginPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ClientRegisterPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderLoginPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderRegisterPage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderHomePage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderEquipmentDetailPage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderClientsTechniciansPage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderClientAccountPage.dart';

import 'package:osito_polar_app/feature/authentication/presentation/providers/RegisterProvider.dart';
// ¡MODIFICADO! main() ahora es async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ¡MODIFICADO! Esperamos a que 'setupLocator' termine
  await setupLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => sl<ProviderLoginProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<ProviderHomeProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<RegisterProvider>(),
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
      theme: ThemeData(
        // ... (tu tema) ...
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      initialRoute: '/select_profile',
      routes: {
        // --- RUTAS DE AUTENTICACIÓN ---
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

        // ¡MODIFICADO! Esta ruta ahora está conectada al Provider
        '/provider_register': (context) => ProviderRegisterPage(
          // onSignUpClicked: (businessName, username, password) {
          //   Navigator.pop(context);
          // },
          onSignInClicked: () {
            Navigator.pop(context);
          },
        ),

        // --- RUTAS DEL DASHBOARD (ya estaban bien) ---
        '/provider_home': (context) => const ProviderHomePage(),
        '/provider_equipment_detail': (context) =>
        const ProviderEquipmentDetailPage(),
        '/provider_clients_technicians': (context) =>
        const ProviderClientsTechniciansPage(),
        '/provider_client_account': (context) =>
        const ProviderClientAccountPage(),
      },
    );
  }
}