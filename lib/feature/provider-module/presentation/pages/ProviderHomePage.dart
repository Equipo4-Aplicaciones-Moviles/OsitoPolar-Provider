import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- PÁGINAS HIJAS ---
import 'package:osito_polar_app/feature/equipment/presentation/pages/MyEquipmentPage.dart';
import 'package:osito_polar_app/feature/service_request/presentation/pages/MarketplacePage.dart';
import 'package:osito_polar_app/feature/provider-module/presentation/pages/ProviderProfilePage.dart';
import 'package:osito_polar_app/feature/technician/presentation/pages/ProviderClientsTechniciansPage.dart';

// Aquí importamos el Dashboard que acabamos de crear arriba


// --- COMPONENTES ---


import '../../../provider-dashboard/presentation/pages/ProviderDashboardContent.dart';
import '../../../provider-dashboard/presentation/widgets/ProviderBottomNavBar.dart';

class ProviderHomePage extends StatefulWidget {
  const ProviderHomePage({super.key});

  @override
  State<ProviderHomePage> createState() => _ProviderHomePageState();
}

class _ProviderHomePageState extends State<ProviderHomePage> {
  // 1. ESTADO
  int _selectedIndex = 0;

  // 2. LISTA DE PÁGINAS (Orden exacto de tu BottomNavBar)
  final List<Widget> _pages = [
    const ProviderDashboardContent(),         // 0: Resumen (Dashboard)
    const MyEquipmentPage(),                  // 1: Equipos
    const MarketplacePage(),                  // 2: Marketplace
    const ProviderClientsTechniciansPage(),   // 3: Técnicos
    const ProviderProfilePage(),              // 4: Perfil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack mantiene el estado de las páginas vivas
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      bottomNavigationBar: ProviderBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}