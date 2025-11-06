import 'package:flutter/material.dart';
// ¡Este import ahora funcionará!
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// --- ¡¡¡IMPORTACIONES CORREGIDAS!!! ---
// Usando los nombres de archivo exactos que tú creaste (PascalCase)
import 'EquipmentControlCard.dart';
import 'TemperatureAnalysisCard.dart';
// -------------------------------------

const Color OsitoPolarAccentBlue = Color(0xFF1565C0);

class ControlCarousel extends StatefulWidget {
  const ControlCarousel({super.key});

  @override
  State<ControlCarousel> createState() => _ControlCarouselState();
}

class _ControlCarouselState extends State<ControlCarousel> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 450,
          child: PageView(
            controller: _pageController,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const EquipmentControlCard(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                // ¡NO CONSTANTE! para que el botón de navegación funcione
                child: TemperatureAnalysisCard(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SmoothPageIndicator(
          controller: _pageController,
          count: 2,
          effect: WormEffect(
            dotHeight: 10,
            dotWidth: 10,
            activeDotColor: OsitoPolarAccentBlue,
            dotColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }
}