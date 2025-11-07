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

// (Comentado porque estos SÍ son snake_case en mi contexto)
// import 'package:osito_polar_app/features/provider_dashboard/presentation/pages/provider_home_page.dart';
// ... (etc) ...
// (Asumiendo que tus archivos se llaman así y están en esa ruta)
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderHomePage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderEquipmentDetailPage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderClientsTechniciansPage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderClientAccountPage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator(); // Llama a tu 'ServiceLocator.dart'

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
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
        '/provider_register': (context) => ProviderRegisterPage(
          onSignUpClicked: (businessName, username, password) {
            Navigator.pop(context);
          },
          onSignInClicked: () {
            Navigator.pop(context);
          },
        ),

        // --- ¡RUTAS DEL DASHBOARD DESCOMENTADAS! ---
        '/provider_home': (context) => const ProviderHomePage(),
        '/provider_equipment_detail': (context) =>
        const ProviderEquipmentDetailPage(),
        '/provider_clients_technicians': (context) =>
        const ProviderClientsTechniciansPage(),
        '/provider_client_account': (context) =>
        const ProviderClientAccountPage(),

        // --- RUTAS DE CLIENTE (AÚN COMENTADAS) ---
        // TODO: Añadir las rutas del dashboard del cliente aquí
        // '/client_home': (context) => const ClientHomePage(),
      },
    );
  }
}
