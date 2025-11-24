import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:osito_polar_app/core/di/ServiceLocator.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';

// --- RUTAS ---
import 'package:osito_polar_app/core/routing/app_route.dart';

// --- Providers ---
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/RegisterProvider.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/AddEquipmentProvider.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/EquipmentDetailProvider.dart';
import 'package:osito_polar_app/feature/technician/presentation/providers/TechnicianProvider.dart';
import 'package:osito_polar_app/feature/technician/presentation/providers/TechnicianDetailProvider.dart';
import 'package:osito_polar_app/feature/provider-dashboard/presentation/providers/ProviderHomeProvider.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/EquipmentProvider.dart';
import 'package:osito_polar_app/feature/service_request/presentation/providers/MarketplaceProvider.dart';

// --- Páginas ---
import 'package:osito_polar_app/feature/onboarding/presentation/screens/GetStartedScreen.dart';
import 'package:osito_polar_app/feature/onboarding/presentation/screens/SelectProfileScreen.dart';

import 'package:osito_polar_app/feature/authentication/presentation/pages/ClientLoginPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ClientRegisterPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderLoginPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderRegisterPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderRegistrationSuccessPage.dart';
import 'package:osito_polar_app/feature/equipment/presentation/pages/AddEquipmentPage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderEquipmentDetailPage.dart';
import 'package:osito_polar_app/feature/technician/presentation/pages/ProviderClientsTechniciansPage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderClientAccountPage.dart';
import 'package:osito_polar_app/feature/technician/presentation/pages/TechniciansDetailPage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderHomePage.dart';
import 'package:osito_polar_app/feature/equipment/presentation/pages/MyEquipmentPage.dart';
import 'package:osito_polar_app/feature/service_request/presentation/pages/MarketplacePage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await setupLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<ProviderLoginProvider>()),
        ChangeNotifierProvider(create: (_) => sl<RegisterProvider>()),
        ChangeNotifierProvider(create: (_) => sl<AddEquipmentProvider>()),
        ChangeNotifierProvider(create: (_) => sl<EquipmentDetailProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ProviderHomeProvider>()),
        ChangeNotifierProvider(create: (_) => sl<EquipmentProvider>()),
        ChangeNotifierProvider(create: (_) => sl<MarketplaceProvider>()),
        ChangeNotifierProvider(create: (_) => sl<TechnicianProvider>()),
        ChangeNotifierProvider(create: (_) => sl<TechnicianDetailProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  String? _lastProcessedSessionId;

  @override
  void initState() {
    super.initState();
    _initAppLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initAppLinks() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleLink(initialUri);
      }
      _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
        _handleLink(uri);
      });
    } catch (e) {
      print('Error al inicializar app_links: $e');
    }
  }

  void _handleLink(Uri uri) {
    if (uri.host == 'ositopolar-42d82.web.app' && uri.path == '/registration/success') {
      final String? sessionId = uri.queryParameters['session_id'];
      if (sessionId == null || sessionId.isEmpty) return;
      if (sessionId == _lastProcessedSessionId) return;

      _lastProcessedSessionId = sessionId;
      final String fullPath = uri.path + (uri.hasQuery ? '?${uri.query}' : '');

      _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        fullPath,
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'OsitoPolar App',

      // --- CONFIGURACIÓN VISUAL ---
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryButton,
          primary: AppColors.primaryButton,
          background: AppColors.backgroundLight,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
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
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryButton,
          ),
        ),
      ),

      // --- RUTA INICIAL ---
      initialRoute: AppRoute.getStarted,

      onGenerateRoute: (settings) {
        // ------------------------------------------------------------------
        // CORRECCIÓN AQUÍ: Manejo del Deep Link pasando datos genéricos
        // ------------------------------------------------------------------
        if (settings.name != null && settings.name!.startsWith('/registration/success')) {
          final Uri uri = Uri.parse(settings.name!);
          final String? sessionId = uri.queryParameters['session_id'];

          return MaterialPageRoute(
            builder: (context) => ProviderRegistrationSuccessPage(
              sessionId: sessionId,
              // Como venimos de un link externo, no tenemos los datos del form,
              // así que ponemos un placeholder o indicamos que verifique su correo.
              username: "Usuario Verificado",
              password: "*** (Revisa tu correo) ***",
            ),
          );
        }

        switch (settings.name) {
          case AppRoute.getStarted:
            return MaterialPageRoute(builder: (context) => const GetStartedScreen());

          case AppRoute.selectProfile:
            return MaterialPageRoute(builder: (context) => const SelectProfileScreen());

          case AppRoute.clientLogin:
          case '/client_login':
            return MaterialPageRoute(builder: (context) => ClientLoginPage(
              onLoginClicked: (username, password) {},
              onRegisterClicked: () => Navigator.pushNamed(context, AppRoute.clientRegister),
              onForgotPasswordClicked: () {},
            ));

          case AppRoute.providerLogin:
          case '/provider_login':
            return MaterialPageRoute(builder: (context) => ProviderLoginPage(
              onRegisterClicked: () => Navigator.pushNamed(context, AppRoute.providerRegister),
              onForgotPasswordClicked: () {},
            ));

          case AppRoute.clientRegister:
          case '/client_register':
            return MaterialPageRoute(builder: (context) => ClientRegisterPage(
              onSignUpClicked: (username, password) => Navigator.pop(context),
              onSignInClicked: () => Navigator.pop(context),
            ));

          case AppRoute.providerRegister:
          case '/provider_register':
            return MaterialPageRoute(builder: (context) => const ProviderRegisterPage());

          case AppRoute.providerHome:
          case '/provider_home':
            return MaterialPageRoute(builder: (context) => const ProviderHomePage());

          case AppRoute.providerMyEquipments:
          case '/provider_my_equipments':
            return MaterialPageRoute(builder: (context) => MyEquipmentPage());

          case AppRoute.providerMarketplace:
          case '/provider_marketplace':
            return MaterialPageRoute(builder: (context) => const MarketplacePage());

          case AppRoute.providerAddEquipment:
          case '/provider_add_equipment':
            final equipmentId = settings.arguments as int?;
            return MaterialPageRoute(
              builder: (context) => AddEquipmentPage(equipmentId: equipmentId),
            );

          case AppRoute.providerTechnicianDetail:
          case '/provider_technician_detail':
            final technicianId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => TechnicianDetailPage(technicianId: technicianId),
            );

          case AppRoute.providerEquipmentDetail:
          case '/provider_equipment_detail':
            return MaterialPageRoute(builder: (context) => const ProviderEquipmentDetailPage());

          case AppRoute.providerClientsTechnicians:
          case '/provider_clients_technicians':
            return MaterialPageRoute(builder: (context) => const ProviderClientsTechniciansPage());

          case AppRoute.providerClientAccount:
          case '/provider_client_account':
            return MaterialPageRoute(builder: (context) => const ProviderClientAccountPage());

          default:
            return MaterialPageRoute(builder: (context) => const GetStartedScreen());
        }
      },
    );
  }
}