import 'package:flutter/material.dart';
import '../widgets/ProfileCard.dart';
import '../../../../core/ui/widgets/OsitoButton.dart';
import '../../../../core/routing/app_route.dart';
import '../../../../core/theme/app_colors.dart';

enum ProfileType { client, company }

class SelectProfileScreen extends StatefulWidget {
  const SelectProfileScreen({super.key});

  @override
  State<SelectProfileScreen> createState() => _SelectProfileScreenState();
}

class _SelectProfileScreenState extends State<SelectProfileScreen> {
  ProfileType? _selectedProfile = ProfileType.client;

  @override
  Widget build(BuildContext context) {

    void onContinue() {
      if (_selectedProfile == ProfileType.client) {
        Navigator.pushNamed(context, AppRoute.clientLogin);
      } else if (_selectedProfile == ProfileType.company) {
        Navigator.pushNamed(context, AppRoute.providerLogin);
      }
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.onboardingGradientStart,
              AppColors.onboardingGradientEnd,
            ],
            stops: [0.1, 0.7],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 40.0),
                    children: [
                      ProfileCard(
                        title: 'Soy un\nCliente',
                        description: 'Quiero monitorear mis equipos de frío y gestionar el mantenimiento.',
                        icon: Icons.storefront_outlined,
                        isSelected: _selectedProfile == ProfileType.client,
                        onTap: () => setState(() => _selectedProfile = ProfileType.client),
                      ),
                      const SizedBox(height: 20),
                      ProfileCard(
                        title: 'Soy una\nEmpresa',
                        description: 'Quiero gestionar el inventario de equipos y las ventas.',
                        icon: Icons.inventory_2_outlined,
                        isSelected: _selectedProfile == ProfileType.company,
                        onTap: () => setState(() => _selectedProfile = ProfileType.company),
                      ),
                    ],
                  ),
                ),

                OsitoButton(
                  text: 'Continuar',
                  onPressed: onContinue,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}