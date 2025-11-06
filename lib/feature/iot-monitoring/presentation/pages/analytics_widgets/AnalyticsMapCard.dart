import 'package:flutter/material.dart';

// Color del Figma
const Color OsitoPolarAccentBlue = Color(0xFF1565C0);

class AnalyticsMapCard extends StatelessWidget {
  const AnalyticsMapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Equipment Location',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: OsitoPolarAccentBlue,
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder para el mapa
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '[Placeholder de Mapa]',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Av Arnaldo Marquez 121',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}