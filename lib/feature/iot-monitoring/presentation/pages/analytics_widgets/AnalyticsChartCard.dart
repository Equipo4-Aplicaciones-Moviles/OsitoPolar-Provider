import 'package:flutter/material.dart';

class AnalyticsChartCard extends StatelessWidget {
  final String title;
  const AnalyticsChartCard({super.key, required this.title});

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
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            // Este es el placeholder para tus gráficas
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '[Placeholder de Gráfica]',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}