import 'package:flutter/material.dart';

// 🎨 Colores personalizados
const Color OsitoPolarAccentBlue = Color(0xFF1565C0);
const Color OsitoPolarButtonBlue = Color(0xFF1976D2);

class TemperatureAnalysisCard extends StatelessWidget {
  // ¡NO CONSTANTE!
  TemperatureAnalysisCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Análisis de temperatura',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Temperatura actual'),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                '22.5°',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: OsitoPolarAccentBlue,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Historial de temperatura'),
            const SizedBox(height: 12),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                    '[Placeholder de Gráfica]',
                    style: TextStyle(color: Colors.grey.shade500)
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                // --- ¡¡¡AQUÍ ESTÁ LA NAVEGACIÓN!!! ---
                onPressed: () {
                  // Navega a la nueva ruta de analíticas
                  Navigator.pushNamed(context, '/equipment_analytics');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: OsitoPolarButtonBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Ver las estadísticas completas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}