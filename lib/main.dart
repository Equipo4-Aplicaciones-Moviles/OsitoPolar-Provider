import 'package:flutter/material.dart';
import 'dart:async'; // Para el StreamSubscription
import 'package:flutter/services.dart' show PlatformException; // Para errores de link
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:osito_polar_app/core/di/ServiceLocator.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

// --- Importamos el paquete 'app_links' ---
import 'package:app_links/app_links.dart';

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
import 'package:osito_polar_app/feature/authentication/presentation/pages/SelectProfilePage.dart';
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
        // Auth
        ChangeNotifierProvider(create: (_) => sl<ProviderLoginProvider>()),
        ChangeNotifierProvider(create: (_) => sl<RegisterProvider>()),

        // Forms (Add/Detail)
        ChangeNotifierProvider(create: (_) => sl<AddEquipmentProvider>()),
        ChangeNotifierProvider(create: (_) => sl<EquipmentDetailProvider>()),

        ChangeNotifierProvider(create: (_) => sl<ProviderHomeProvider>()),
        ChangeNotifierProvider(create: (_) => sl<EquipmentProvider>()),
        ChangeNotifierProvider(create: (_) => sl<MarketplaceProvider>()),

        ChangeNotifierProvider(create: (_) => sl<TechnicianProvider>()),
        ChangeNotifierProvider(create: (_) => sl<TechnicianDetailProvider>()),
      ],
      child: MyApp(),
    ),
  );
}

// Convertido a StatefulWidget para "escuchar" links
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  // --- ¡SEGURO MEJORADO! ---
  // Guardamos el último ID de sesión que procesamos
  // para no procesarlo dos veces.
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
        print('Link inicial (app cerrada): $initialUri');
        _handleLink(initialUri);
      }

      _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
        print('Link recibido (app abierta): $uri');
        _handleLink(uri);
      });

    } catch (e) {
      print('Error al inicializar app_links: $e');
    }
  }

  // --- Lógica de 'handleLink' con el seguro mejorado ---
  void _handleLink(Uri uri) {
    print('Link recibido: $uri');

    // Comprueba si es nuestro link de Stripe
    if (uri.host == 'ositopolar-42d82.web.app' &&
        uri.path == '/registration/success') {

      // Extrae el session_id
      final String? sessionId = uri.queryParameters['session_id'];

      // --- ¡LÓGICA DEL SEGURO MEJORADA! ---
      // 1. Si no hay session_id, no hagas nada.
      if (sessionId == null || sessionId.isEmpty) {
        print('Link de éxito sin session_id. Ignorando.');
        return;
      }
      // 2. Si ya procesamos este ID, no hagas nada.
      if (sessionId == _lastProcessedSessionId) {
        print('Link duplicado con el mismo session_id ($sessionId). Ignorando.');
        return;
      }

      // 3. ¡Es un link nuevo! Guárdalo y procésalo.
      print('¡Procesando nuevo session_id!: $sessionId');
      _lastProcessedSessionId = sessionId;

      // (Tu lógica de navegación se queda igual)
      final String fullPath = uri.path + (uri.hasQuery ? '?${uri.query}' : '');

      _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        fullPath,
            (route) => false,
      );
    }
  }

  // --- Tu método BUILD se queda igual ---
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'OsitoPolar App',
      theme: ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryButton,
          primary: AppColors.primaryButton,
          background: AppColors.backgroundLight,
        ),
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
      initialRoute: '/select_profile',

      // --- Tu 'onGenerateRoute' se queda igual ---
      onGenerateRoute: (settings) {

        // Esta lógica ya está perfecta
        if (settings.name != null &&
            settings.name!.startsWith('/registration/success')) {

          final Uri uri = Uri.parse(settings.name!);
          final String? sessionId = uri.queryParameters['session_id'];

          print('Navegando a Pág. de Éxito con ID: $sessionId');

          return MaterialPageRoute(
            builder: (context) => ProviderRegistrationSuccessPage(
              sessionId: sessionId,
            ),
          );
        }

        // Tu lógica de rutas existente se queda igual
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
          case '/provider_home':
            return MaterialPageRoute(builder: (context) => const ProviderHomePage());
          case '/provider_my_equipments':
            return MaterialPageRoute(builder: (context) => MyEquipmentPage());
          case '/provider_marketplace':
            return MaterialPageRoute(builder: (context) => const MarketplacePage());
          case '/provider_add_equipment':
            final equipmentId = settings.arguments as int?;
            return MaterialPageRoute(
              builder: (context) => AddEquipmentPage(equipmentId: equipmentId),
            );
          case '/provider_technician_detail':
            final technicianId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => TechnicianDetailPage(technicianId: technicianId),
            );
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