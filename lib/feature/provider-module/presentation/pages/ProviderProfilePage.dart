import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';

// Importamos los providers necesarios
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';
import '../providers/ProviderProfileProvider.dart';

class ProviderProfilePage extends StatefulWidget {
  const ProviderProfilePage({super.key});

  @override
  State<ProviderProfilePage> createState() => _ProviderProfilePageState();
}

class _ProviderProfilePageState extends State<ProviderProfilePage> {

  @override
  void initState() {
    super.initState();
    // 1. Obtenemos el ID del usuario logueado
    final loginProvider = context.read<ProviderLoginProvider>();
    final userId = loginProvider.user?.id;

    if (userId != null) {
      // 2. Cargamos el perfil completo usando ese ID
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProviderProfileProvider>().loadProfile(userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos los cambios en el perfil
    final profileProvider = context.watch<ProviderProfileProvider>();
    final profile = profileProvider.profile;
    final isLoading = profileProvider.isLoading;

    // Datos por defecto (mientras carga o si es null)
    final String companyName = profile?.companyName ?? "Cargando empresa...";
    final String taxId = profile?.taxId ?? "---";
    final String planName = profile?.planName ?? "---";
    final double balance = profile?.balance ?? 0.00;

    // Obtenemos el email del LoginProvider ya que ese sí lo tenemos seguro
    final email = context.read<ProviderLoginProvider>().user?.username ?? "usuario";

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
            "Mi Perfil",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Sin flecha de atrás en el dashboard
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {
              // Navegar a Configuración si existe
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryButton))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- CABECERA DE PERFIL ---
            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primaryButton,
                child: Icon(Icons.business, size: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              companyName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              email, // Mostramos username o email
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Text(
                planName,
                style: const TextStyle(
                    color: AppColors.primaryButton,
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- SECCIÓN 1: BALANCE ---
            _buildInfoCard(
              title: "Balance Disponible",
              icon: Icons.account_balance_wallet,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "S/ ${balance.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.green),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica futura: /api/v1/provider-withdrawals/request
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Función de retiro próximamente"))
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                      elevation: 0,
                    ),
                    child: const Text("Retirar", style: TextStyle(fontSize: 12, color: Colors.white)),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- SECCIÓN 2: DATOS DE EMPRESA ---
            _buildInfoCard(
              title: "Información de la Empresa",
              icon: Icons.store,
              child: Column(
                children: [
                  _buildRowItem("Razón Social", companyName),
                  const Divider(),
                  _buildRowItem("RUC / Tax ID", taxId),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- SECCIÓN 3: ESTADÍSTICAS DEL PLAN ---
            _buildInfoCard(
              title: "Uso del Plan",
              icon: Icons.pie_chart,
              child: Column(
                children: [
                  _buildUsageBar(
                      label: "Clientes",
                      current: profile?.currentClientCount ?? 0,
                      max: profile?.maxClients ?? 100
                  ),
                  const SizedBox(height: 15),
                  _buildUsageBar(
                      label: "Solicitudes Activas",
                      current: profile?.activeServiceRequests ?? 0,
                      max: 50, // Ejemplo, o traerlo del plan
                      color: Colors.orange
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- SECCIÓN 4: SEGURIDAD (2FA) ---
            _buildInfoCard(
              title: "Seguridad",
              icon: Icons.security,
              child: InkWell(
                onTap: () {
                  // Navegar a la pantalla de configuración 2FA
                  Navigator.pushNamed(context, '/2fa_setup');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.phonelink_lock, color: Colors.grey),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Configurar autenticación de dos pasos (2FA)",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- BOTÓN CERRAR SESIÓN ---
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Logout
                  context.read<ProviderLoginProvider>().logout();
                  Navigator.pushNamedAndRemoveUntil(context, '/get_started', (route) => false);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Cerrar Sesión", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildInfoCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryButton, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildUsageBar({required String label, required int current, required int max, Color color = AppColors.primaryButton}) {
    double percent = (max == 0) ? 0 : (current / max);
    if (percent > 1) percent = 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            Text("$current / $max", style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percent,
          backgroundColor: Colors.grey.shade200,
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}