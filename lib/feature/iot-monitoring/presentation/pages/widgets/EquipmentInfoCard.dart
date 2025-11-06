import 'package:flutter/material.dart';

class EquipmentInfoCard extends StatelessWidget {
  const EquipmentInfoCard({super.key});

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
              'Información del equipo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoPair('Nombre', 'Industrial freezer XX-400'),
                      _infoPair('Modelo', 'XK-400'),
                      _infoPair('Número de serie', 'XK400-12345'),
                      _infoPair('Día de instalación', '9/01/2023'),
                      _infoPair('Ubicación', 'San Isidro Main WareHouse'),
                      _infoPair('Notas', ''),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoPair('Tipo', 'Congeladora'),
                      _infoPair('Manufactura', 'CoolTech'),
                      _infoPair('Código', 'CONG-001'),
                      _infoPair('Consumo de energía', '320 watts'),
                      _infoPair('Dirección', 'Av. Javier Prado Este 4200, San Isidro, Lima'),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _infoPair(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}