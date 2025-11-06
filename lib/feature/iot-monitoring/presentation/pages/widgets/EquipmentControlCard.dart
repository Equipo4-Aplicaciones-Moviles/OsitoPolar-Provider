import 'package:flutter/material.dart';

// 🎨 Colores personalizados
const Color OsitoPolarGreen = Color(0xFF4CAF50);
const Color OsitoPolarButtonBlue = Color(0xFF1976D2);

class EquipmentControlCard extends StatelessWidget {
  const EquipmentControlCard({super.key});

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
              'Control de equipo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            const Text('Configuración de encendido'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Column(
                  children: [
                    Icon(Icons.power_off, color: Colors.grey, size: 30),
                    Text('On'),
                  ],
                ),
                const SizedBox(width: 40),
                Column(
                  children: [
                    Icon(Icons.power_settings_new, color: OsitoPolarGreen, size: 30),
                    Text('Power', style: TextStyle(color: OsitoPolarGreen)),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),
            const Text('Configuración de temperatura'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: () {},
                  mini: true,
                  backgroundColor: Colors.grey.shade200,
                  elevation: 0,
                  child: Icon(Icons.remove, color: Colors.black),
                ),
                Column(
                  children: [
                    Text('22.5°', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                    Text('Current', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
                Column(
                  children: [
                    Text('22.0°', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Set', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                FloatingActionButton(
                  onPressed: () {},
                  mini: true,
                  backgroundColor: OsitoPolarButtonBlue,
                  elevation: 1,
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Optimal range: 18.0° - 25.0°',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}