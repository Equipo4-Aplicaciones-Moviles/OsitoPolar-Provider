import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para SystemChrome
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart'; // Importante para el redirect

// --- DI & THEME ---
import 'package:osito_polar_app/core/di/ServiceLocator.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/core/routing/app_route.dart'; // Asegúrate de tener este archivo de rutas

// --- PROVIDERS ---
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/RegisterProvider.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/AddEquipmentProvider.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/EquipmentDetailProvider.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/EquipmentProvider.dart';
import 'package:osito_polar_app/feature/provider-dashboard/presentation/providers/ProviderHomeProvider.dart';
import 'package:osito_polar_app/feature/service_request/presentation/providers/MarketplaceProvider.dart';
import 'package:osito_polar_app/feature/technician/presentation/providers/TechnicianProvider.dart';
import 'package:osito_polar_app/feature/technician/presentation/providers/TechnicianDetailProvider.dart';


// --- PÁGINAS ---
// Onboarding (Diseño Nuevo)
import 'package:osito_polar_app/feature/onboarding/presentation/screens/GetStartedScreen.dart';
import 'package:osito_polar_app/feature/onboarding/presentation/screens/SelectProfileScreen.dart';

// Auth
import 'package:osito_polar_app/feature/authentication/presentation/pages/ClientLoginPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ClientRegisterPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderLoginPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderRegisterPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderRegistrationSuccessPage.dart';

// Provider Module
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderHomePage.dart';
import 'package:osito_polar_app/feature/equipment/presentation/pages/MyEquipmentPage.dart';
import 'package:osito_polar_app/feature/equipment/presentation/pages/AddEquipmentPage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderEquipmentDetailPage.dart';
import 'package:osito_polar_app/feature/service_request/presentation/pages/MarketplacePage.dart';

import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderClientAccountPage.dart';


import 'feature/technician/presentation/pages/ProviderClientsTechniciansPage.dart';
import 'feature/technician/presentation/pages/TechniciansDetailPage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await setupLocator();

  // Configuración opcional de UI (Barra de estado transparente)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

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
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

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

  // --- CONFIGURACIÓN DE DEEP LINKS ---
  Future<void> _initAppLinks() async {
    _appLinks = AppLinks();

    // 1. Link Inicial (Si la app estaba cerrada y se abre por un link)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      print('Error obteniendo link inicial: $e');
    }

    // 2. Stream de Links (Si la app está en segundo plano)
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    print("🔗 Link Recibido: $uri");

    final sessionId = uri.queryParameters['session_id'];

    if (sessionId != null) {
      print("✅ Session ID encontrado: $sessionId");

      // SOLUCIÓN: Esperar a que el frame se dibuje antes de navegar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Verificamos si el navegador está listo
        if (_navigatorKey.currentState != null) {
          print("🚀 Navegando a SuccessPage...");
          _navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => ProviderRegistrationSuccessPage(sessionId: sessionId),
            ),
                (route) => false, // Esto borra el historial para que no pueda volver atrás
          );
        } else {
          print("⚠️ El Navigator aún no estaba listo");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey, // ¡Crucial para la navegación sin context!
      title: 'OsitoPolar App',
      debugShowCheckedModeBanner: false,

      // --- TEMA GLOBAL (Para evitar el morado) ---
      theme: ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryButton,
          primary: AppColors.primaryButton,
          background: AppColors.backgroundLight,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,

        // Estilo de Botones
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryButton,
            foregroundColor: AppColors.buttonLabel,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
        ),

        // Estilo de Inputs
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
      ),

      // --- RUTA INICIAL (ONBOARDING) ---
      initialRoute: AppRoute.getStarted, // <-- ¡Tu diseño nuevo!

      // --- GENERADOR DE RUTAS ---
      onGenerateRoute: (settings) {

        // Manejo especial para el link de éxito en WEB (si usas #/)
        if (settings.name != null && settings.name!.startsWith('/registration/success')) {
          final uri = Uri.parse(settings.name!);
          final sessionId = uri.queryParameters['session_id'];
          return MaterialPageRoute(
            builder: (context) => ProviderRegistrationSuccessPage(sessionId: sessionId),
          );
        }

        switch (settings.name) {
        // --- ONBOARDING ---
          case AppRoute.getStarted:
            return MaterialPageRoute(builder: (context) => const GetStartedScreen());

          case AppRoute.selectProfile:
            return MaterialPageRoute(builder: (context) => const SelectProfileScreen());

        // --- AUTH ---
          case AppRoute.clientLogin: // '/client_login'
            return MaterialPageRoute(builder: (context) => ClientLoginPage(
              onLoginClicked: (u, p) {},
              onRegisterClicked: () => Navigator.pushNamed(context, AppRoute.clientRegister),
              onForgotPasswordClicked: () {},
            ));
          case AppRoute.clientRegister: // '/client_register'
            return MaterialPageRoute(builder: (context) => ClientRegisterPage(
              onSignUpClicked: (u, p) => Navigator.pop(context),
              onSignInClicked: () => Navigator.pop(context),
            ));

          case AppRoute.providerLogin: // '/provider_login'
            return MaterialPageRoute(builder: (context) => ProviderLoginPage(
              onRegisterClicked: () => Navigator.pushNamed(context, AppRoute.providerRegister),
              onForgotPasswordClicked: () {},
            ));
          case AppRoute.providerRegister: // '/provider_register'
            return MaterialPageRoute(builder: (context) => ProviderRegisterPage(
              onSignInClicked: () => Navigator.pop(context),
            ));

        // --- PROVIDER MODULE ---
          case '/provider_home': // Dashboard
            return MaterialPageRoute(builder: (context) => const ProviderHomePage());

          case '/provider_my_equipments': // Inventario
            return MaterialPageRoute(builder: (context) => const MyEquipmentPage());

          case '/provider_marketplace': // Marketplace
            return MaterialPageRoute(builder: (context) => const MarketplacePage());

          case '/provider_clients_technicians': // Técnicos
            return MaterialPageRoute(builder: (context) => const ProviderClientsTechniciansPage());


        // --- SUB-PÁGINAS ---
          case '/provider_add_equipment':
            final equipmentId = settings.arguments as int?;
            return MaterialPageRoute(builder: (context) => AddEquipmentPage(equipmentId: equipmentId));

          case '/provider_technician_detail':
            final technicianId = settings.arguments as int;
            return MaterialPageRoute(builder: (context) => TechnicianDetailPage(technicianId: technicianId));


        // Default
          default:
            return MaterialPageRoute(builder: (context) => const GetStartedScreen());
        }
      },
    );
  }
}