import 'package:flutter/material.dart';

// --- Tus Páginas ---
import 'package:osito_polar_app/feature/iot-monitoring/presentation/pages/EquipmentControlPage.dart';
import 'package:osito_polar_app/feature/iot-monitoring/presentation/pages/EquipmentAnalyticsPage.dart';
// (Importa aquí tus otras páginas si las tienes, como ProviderHomePage)
// import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderHomePage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // --- ¡¡¡AQUÍ ESTÁ LA LÍNEA!!! ---
      // Esto quita las etiquetas "DEBUG" y "SLOW MODE"
      debugShowCheckedModeBanner: false,
      // ---------------------------------

      title: 'OsitoPolar App',
      // ... (aquí iría tu 'theme')

      initialRoute: '/equipment_control',

      routes: {
        // Tu ruta de home (si existe en esta rama)
        // '/provider_home': (context) => const ProviderHomePage(),

        // --- Tus Rutas de IoT ---
        '/equipment_control': (context) => const EquipmentControlPage(),
        '/equipment_analytics': (context) => const EquipmentAnalyticsPage(),
      },
    );
  }
}