import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:osito_polar_app/core/di/ServiceLocator.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/core/di/ServiceLocator.dart';
import 'package:provider/provider.dart';

// --- Providers ---
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/EquipmentDetailProvider.dart';
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
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderRegistrationSuccessPage.dart'; // <-- ¡NUEVO!
import 'package:osito_polar_app/feature/authentication/presentation/providers/RegisterProvider.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/AddEquipmentProvider.dart';
import 'package:osito_polar_app/feature/equipment/presentation/pages/AddEquipmentPage.dart';
import 'package:osito_polar_app/feature/equipment/presentation/pages/MyEquipmentPage.dart';
// ¡MODIFICADO! main() ahora es async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ¡MODIFICADO! Esperamos a que 'setupLocator' termine
  await dotenv.load(fileName: ".env");
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
        ChangeNotifierProvider(
          create: (_) => sl<AddEquipmentProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<EquipmentDetailProvider>(),
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
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      // 'initialRoute' le dice a la app dónde empezar
      // si se carga desde la URL base (ej. localhost:3000)
      initialRoute: '/select_profile',

      // ¡AQUÍ ESTÁ LA MAGIA!
      // Borramos el 'routes: { ... }' y lo reemplazamos con 'onGenerateRoute'
      onGenerateRoute: (settings) {
        // 'settings.name' es la ruta que la app intenta cargar
        // ej: "/provider_login" o "/registration/success?session_id=..."

        // --- ¡AQUÍ ESTÁ LA SOLUCIÓN! ---
        // Comprobamos si la ruta *comienza con* /registration/success
        // Esto ignora la parte de ?session_id=...
        if (settings.name != null &&
            settings.name!.startsWith('/registration/success')) {
          return MaterialPageRoute(
            builder: (context) => const ProviderRegistrationSuccessPage(),
          );
        }

        // --- El resto de tus rutas, ahora en un 'switch' ---
        switch (settings.name) {
          case '/select_profile':
            return MaterialPageRoute(
              builder: (context) => SelectProfilePage(
                onClientClicked: () {
                  Navigator.pushNamed(context, '/client_login');
                },
                onProviderClicked: () {
                  Navigator.pushNamed(context, '/provider_login');
                },
              ),
            );

          case '/client_login':
            return MaterialPageRoute(
              builder: (context) => ClientLoginPage(
                onLoginClicked: (username, password) {},
                onRegisterClicked: () {
                  Navigator.pushNamed(context, '/client_register');
                },
                onForgotPasswordClicked: () {},
              ),
            );

          case '/client_register':
            return MaterialPageRoute(
              builder: (context) => ClientRegisterPage(
                onSignUpClicked: (username, password) {
                  Navigator.pop(context);
                },
                onSignInClicked: () {
                  Navigator.pop(context);
                },
              ),
            );

          case '/provider_login':
            return MaterialPageRoute(
              builder: (context) => ProviderLoginPage(
                onRegisterClicked: () {
                  Navigator.pushNamed(context, '/provider_register');
                },
                onForgotPasswordClicked: () {},
              ),
            );

          case '/provider_register':
            return MaterialPageRoute(
              builder: (context) => ProviderRegisterPage(
                onSignInClicked: () {
                  Navigator.pop(context);
                },
              ),
            );

          case '/provider_home':
            return MaterialPageRoute(
              builder: (context) => const ProviderHomePage(),
            );

          case '/provider_equipment_detail':
            return MaterialPageRoute(
              builder: (context) => const ProviderEquipmentDetailPage(),
            );

          case '/provider_clients_technicians':
            return MaterialPageRoute(
              builder: (context) => const ProviderClientsTechniciansPage(),
            );

          case '/provider_client_account':
            return MaterialPageRoute(
              builder: (context) => const ProviderClientAccountPage(),
            );

          case '/provider_my_equipments':
            return MaterialPageRoute(
              builder: (context) => MyEquipmentPage(),
            );

          case '/provider_add_equipment':
          // Así manejamos argumentos en onGenerateRoute
            final equipmentId = settings.arguments as int?;
            return MaterialPageRoute(
              builder: (context) => AddEquipmentPage(equipmentId: equipmentId),
            );

        // Una ruta "por defecto" si todo lo demás falla
          default:
            return MaterialPageRoute(
              builder: (context) => SelectProfilePage(
                onClientClicked: () {
                  Navigator.pushNamed(context, '/client_login');
                },
                onProviderClicked: () {
                  Navigator.pushNamed(context, '/provider_login');
                },
              ),
            );
        }
      },
    );
  }
}