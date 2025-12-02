import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';

// --- DI & THEME ---
import 'package:osito_polar_app/core/di/ServiceLocator.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:osito_polar_app/core/routing/app_route.dart';

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
import 'package:osito_polar_app/feature/provider-module/presentation/providers/ProviderProfileProvider.dart';
// --- PÁGINAS ---
import 'package:osito_polar_app/feature/onboarding/presentation/screens/GetStartedScreen.dart';
import 'package:osito_polar_app/feature/onboarding/presentation/screens/SelectProfileScreen.dart'; // Asegúrate que este archivo acepte los callbacks

// Auth Pages
import 'package:osito_polar_app/feature/authentication/presentation/pages/ClientLoginPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ClientRegisterPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderLoginPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderRegisterPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/ProviderRegistrationSuccessPage.dart';
import 'package:osito_polar_app/feature/authentication/presentation/pages/SelectPlanPage.dart'; // <--- IMPORTANTE: Importar SelectPlanPage
import 'package:osito_polar_app/feature/authentication/presentation/pages/TermsPage.dart'; // Importar TermsPage

// Provider Module
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderHomePage.dart';
import 'package:osito_polar_app/feature/equipment/presentation/pages/MyEquipmentPage.dart';
import 'package:osito_polar_app/feature/equipment/presentation/pages/AddEquipmentPage.dart';
import 'package:osito_polar_app/feature/service_request/presentation/pages/MarketplacePage.dart';
import 'package:osito_polar_app/feature/technician/presentation/pages/ProviderClientsTechniciansPage.dart';
import 'package:osito_polar_app/feature/technician/presentation/pages/TechniciansDetailPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await setupLocator();

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
        ChangeNotifierProvider(create: (_) => ProviderProfileProvider()),
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

  Future<void> _initAppLinks() async {
    _appLinks = AppLinks();
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) _handleDeepLink(initialUri);
    } catch (e) {
      debugPrint('Error obteniendo link inicial: $e');
    }
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) => _handleDeepLink(uri));
  }

  void _handleDeepLink(Uri uri) {
    debugPrint("🔗 Link Recibido: $uri");
    final sessionId = uri.queryParameters['session_id'];

    if (sessionId != null) {
      debugPrint("✅ Session ID encontrado: $sessionId");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_navigatorKey.currentState != null) {
          debugPrint("🚀 Navegando a SuccessPage...");
          _navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => ProviderRegistrationSuccessPage(sessionId: sessionId),
            ),
                (route) => false,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'OsitoPolar App',
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        ),
      ),

      initialRoute: AppRoute.getStarted,

      onGenerateRoute: (settings) {
        // Manejo de Deep Link en Web
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
            return MaterialPageRoute(
              builder: (context) => SelectProfileScreen(
                // 1. Si es Cliente -> Login Normal
                onClientClicked: () => Navigator.pushNamed(context, AppRoute.clientLogin),

                // 2. Si es Empresa -> Primero va a SELECCIONAR PLAN
                onProviderClicked: () => Navigator.pushNamed(context, '/select_plan'),
              ),
            );

        // --- NUEVA RUTA: SELECCIÓN DE PLAN ---
          case '/select_plan':
            return MaterialPageRoute(builder: (context) => const SelectPlanPage());

        // --- AUTH ---
          case AppRoute.clientLogin:
            return MaterialPageRoute(builder: (context) => ClientLoginPage(
              onLoginClicked: (u, p) {},
              onRegisterClicked: () => Navigator.pushNamed(context, AppRoute.clientRegister),
              onForgotPasswordClicked: () {},
            ));
          case AppRoute.clientRegister:
            return MaterialPageRoute(builder: (context) => ClientRegisterPage(
              onSignUpClicked: (u, p) => Navigator.pop(context),
              onSignInClicked: () => Navigator.pop(context),
            ));

          case AppRoute.providerLogin:
            return MaterialPageRoute(builder: (context) => ProviderLoginPage(
              onRegisterClicked: () => Navigator.pushNamed(context, '/select_plan'), // Flujo corregido también aquí
              onForgotPasswordClicked: () {},
            ));

          case AppRoute.providerRegister:
          // 3. RECIBIMOS EL ARGUMENTO DEL PLAN
            final args = settings.arguments as int?;
            return MaterialPageRoute(builder: (context) => ProviderRegisterPage(
              planId: args, // Se lo pasamos al registro
              onSignInClicked: () => Navigator.pushNamed(context, AppRoute.providerLogin),
            ));

        // --- PROVIDER MODULE ---
          case '/provider_home':
            return MaterialPageRoute(builder: (context) => const ProviderHomePage());

          case '/provider_my_equipments':
            return MaterialPageRoute(builder: (context) => const MyEquipmentPage());

          case '/provider_marketplace':
            return MaterialPageRoute(builder: (context) => const MarketplacePage());

          case '/provider_clients_technicians':
            return MaterialPageRoute(builder: (context) => const ProviderClientsTechniciansPage());

          case '/terms':
            return MaterialPageRoute(builder: (context) => const TermsPage());

        // --- SUB-PÁGINAS ---
          case '/provider_add_equipment':
            final equipmentId = settings.arguments as int?;
            return MaterialPageRoute(builder: (context) => AddEquipmentPage(equipmentId: equipmentId));

          case '/provider_technician_detail':
            final technicianId = settings.arguments as int;
            return MaterialPageRoute(builder: (context) => TechnicianDetailPage(technicianId: technicianId));

          default:
            return MaterialPageRoute(builder: (context) => const GetStartedScreen());
        }
      },
    );
  }
}