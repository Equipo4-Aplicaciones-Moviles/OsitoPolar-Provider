import 'package:flutter/material.dart';

// Colores del Figma
const Color OsitoPolarAccentBlue = Color(0xFF1565C0);
const Color OsitoPolarRed = Color(0xFFE53935);
const Color OsitoPolarGreenButton = Color(0xFF4CAF50);
const Color OsitoPolarTextLight = Color(0xFF6c757d);

class AnalyticsInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Color valueColor;

  const AnalyticsInfoCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.valueColor = OsitoPolarAccentBlue, // Azul por defecto
  });

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
            Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}