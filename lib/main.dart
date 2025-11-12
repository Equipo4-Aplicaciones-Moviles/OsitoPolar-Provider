import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:osito_polar_app/core/di/ServiceLocator.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

// --- Providers ---
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/RegisterProvider.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/AddEquipmentProvider.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/EquipmentDetailProvider.dart';

// --- ¡NUESTROS 3 PROVIDERS DE APP! ---
import 'package:osito_polar_app/feature/provider-dashboard/presentation/providers/ProviderHomeProvider.dart'; // (Para el Dashboard)
import 'package:osito_polar_app/feature/equipment/presentation/providers/EquipmentProvider.dart';             // (Para Mis Equipos)
import 'package:osito_polar_app/feature/service_request/presentation/providers/MarketplaceProvider.dart';      // (Para Marketplace)

// --- Páginas ---
import 'package:osito_polar_app/feature/authentication/presentation/pages/SelectProfilePage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ClientLoginPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ClientRegisterPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderLoginPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderRegisterPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderRegistrationSuccessPage.dart';
import 'package:osito_polar_app/feature/equipment/presentation/pages/AddEquipmentPage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderEquipmentDetailPage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderClientsTechniciansPage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderClientAccountPage.dart';

// --- ¡Nuestras 3 páginas principales! ---
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderHomePage.dart';     // (El Dashboard/Resumen)
import 'package:osito_polar_app/feature/equipment/presentation/pages/MyEquipmentPage.dart';          // (La Lista de Equipos)
import 'package:osito_polar_app/feature/service_request/presentation/pages/MarketplacePage.dart';     // (La Lista de Trabajos)


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await setupLocator();

  runApp(
    MultiProvider(
      providers: [
        // Auth
        ChangeNotifierProvider(create: (_) => sl<ProviderLoginProvider>()),
        ChangeNotifierProvider(create: (_) => sl<RegisterProvider>()),

        // Forms (Add/Detail)
        ChangeNotifierProvider(create: (_) => sl<AddEquipmentProvider>()),
        ChangeNotifierProvider(create: (_) => sl<EquipmentDetailProvider>()),

        // --- ¡NUESTROS 3 PROVIDERS DE PÁGINA! ---
        ChangeNotifierProvider(create: (_) => sl<ProviderHomeProvider>()),
        ChangeNotifierProvider(create: (_) => sl<EquipmentProvider>()),
        ChangeNotifierProvider(create: (_) => sl<MarketplaceProvider>()),
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

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryButton, // <-- ¡Tu color azul!
          primary: AppColors.primaryButton,
          background: AppColors.backgroundLight,
        ),

        // 2. Define el estilo de los botones (para que usen tu color)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryButton,
            foregroundColor: AppColors.buttonLabel,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
        ),

        // 3. Define el estilo de los campos de texto
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.textFieldBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: AppColors.textFieldBorder, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: AppColors.textFieldBorder, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: AppColors.primaryButton, width: 2),
          ),
          labelStyle: TextStyle(color: AppColors.textColor),
        ),

        // 4. (Opcional) Define el estilo de los TextButton (como el "Cancelar" del diálogo)
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryButton, // <-- Tu color azul
          ),
        ),
      ),
      initialRoute: '/select_profile',
      onGenerateRoute: (settings) {

        if (settings.name != null &&
            settings.name!.startsWith('/registration/success')) {
          return MaterialPageRoute(
            builder: (context) => const ProviderRegistrationSuccessPage(),
          );
        }

        switch (settings.name) {
        // --- Auth ---
          case '/select_profile':
            return MaterialPageRoute(builder: (context) => SelectProfilePage(
              onClientClicked: () => Navigator.pushNamed(context, '/client_login'),
              onProviderClicked: () => Navigator.pushNamed(context, '/provider_login'),
            ));
          case '/provider_login':
            return MaterialPageRoute(builder: (context) => ProviderLoginPage(
              onRegisterClicked: () => Navigator.pushNamed(context, '/provider_register'),
              onForgotPasswordClicked: () {},
            ));
          case '/provider_register':
            return MaterialPageRoute(builder: (context) => ProviderRegisterPage(
              onSignInClicked: () => Navigator.pop(context),
            ));
        // (Tus rutas de cliente)
          case '/client_login':
            return MaterialPageRoute(builder: (context) => ClientLoginPage(/*...*/
              onLoginClicked: (username, password) {},
              onRegisterClicked: () {
                Navigator.pushNamed(context, '/client_register');
              },
              onForgotPasswordClicked: () {},
            )

            );
          case '/client_register':
            return MaterialPageRoute(builder: (context) => ClientRegisterPage(/*...*/
              onSignUpClicked: (username, password) {
                Navigator.pop(context);
              },
              onSignInClicked: () {
                Navigator.pop(context);
              },
            )

            );

        // --- App del Provider ---

        // ¡Ruta del Dashboard/Resumen!
          case '/provider_home':
            return MaterialPageRoute(builder: (context) => const ProviderHomePage());

        // ¡Ruta de la lista detallada de Equipos!
          case '/provider_my_equipments':
            return MaterialPageRoute(builder: (context) => MyEquipmentPage());

        // ¡Ruta de la nueva página del Marketplace!
          case '/provider_marketplace':
            return MaterialPageRoute(builder: (context) => const MarketplacePage());

        // (Formulario de Añadir/Editar Equipo)
          case '/provider_add_equipment':
            final equipmentId = settings.arguments as int?;
            return MaterialPageRoute(
              builder: (context) => AddEquipmentPage(equipmentId: equipmentId),
            );

        // (Otras páginas)
          case '/provider_equipment_detail':
            return MaterialPageRoute(builder: (context) => const ProviderEquipmentDetailPage());
          case '/provider_clients_technicians':
            return MaterialPageRoute(builder: (context) => const ProviderClientsTechniciansPage());
          case '/provider_client_account':
            return MaterialPageRoute(builder: (context) => const ProviderClientAccountPage());

        // Default
          default:
            return MaterialPageRoute(builder: (context) => SelectProfilePage(
              onClientClicked: () => Navigator.pushNamed(context, '/client_login'),
              onProviderClicked: () => Navigator.pushNamed(context, '/provider_login'),
            ));
        }
      },
    );
  }
}