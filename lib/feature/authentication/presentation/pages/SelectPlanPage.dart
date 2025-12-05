import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';

class SelectPlanPage extends StatelessWidget {
  const SelectPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text("Elige tu plan", style: TextStyle(color: AppColors.title, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.iconColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // Tarjeta Plan Básico
          _buildPlanCard(
            context,
            title: "Basic (Polar Bear)",
            price: "\$ 18.99",
            features: [
              "Up to 6 units",
              "Real time temperature monitoring",
              "Critical fault email alerts",
              "Remote on/off control"
            ],
            planId: 4, // ID que enviaremos al backend
            isHighlighted: false,
          ),

          const SizedBox(height: 20),

          // Tarjeta Plan Estándar
          _buildPlanCard(
            context,
            title: "Standard (Snow Bear)",
            price: "\$ 35.13",
            features: [
              "Up to 12 units",
              "Everything in basic",
              "Advanced monitoring",
              "Scheduled maintenance"
            ],
            planId: 5,
            isHighlighted: true, // Este sale diferente en tu diseño (blanco)
          ),

          const SizedBox(height: 20),

          // Tarjeta Plan Pro
          _buildPlanCard(
            context,
            title: "Pro (Ice Bear)",
            price: "\$ 67.56",
            features: [
              "Up to 20 units",
              "Real time monitoring",
              "Maintenance history log",
              "Email support"
            ],
            planId: 6,
            isHighlighted: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, {
    required String title,
    required String price,
    required List<String> features,
    required int planId,
    required bool isHighlighted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.white : const Color(0xFFE8EFF5), // Color grisáceo del diseño
        borderRadius: BorderRadius.circular(20),
        border: isHighlighted ? Border.all(color: Colors.black12) : null,
        boxShadow: isHighlighted ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))] : [],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(price, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.primaryButton)),
              const Text(" /mes", style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Características:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("• ", style: TextStyle(fontSize: 12, color: Colors.black54)),
                Expanded(child: Text(f, style: const TextStyle(fontSize: 12, color: Colors.black54))),
              ],
            ),
          )),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // NAVEGAMOS AL REGISTRO PASANDO EL PLAN ID
                Navigator.pushNamed(context, '/provider_register', arguments: planId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButton,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              child: const Text("Seleccionar plan", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}