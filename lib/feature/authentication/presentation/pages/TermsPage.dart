import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El Scaffold es transparente para que se vea el Container con gradiente de abajo
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. CAPA DE FONDO (Degradado Azul a Blanco)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF90CAF9), // Azul cielo (ajustable)
                  Colors.white,
                ],
                stops: [0.0, 0.4], // El azul ocupa la parte superior
              ),
            ),
          ),

          // 2. CONTENIDO
          SafeArea(
            child: Column(
              children: [
                // --- BARRA SUPERIOR (AppBar Personalizada) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          "Términos y Condiciones",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900, // Extra negrita
                            color: Colors.black,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // Espacio invisible para equilibrar el icono de atrás
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // --- TARJETA BLANCA CON CONTENIDO ---
                Expanded(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // La Tarjeta Blanca
                      Container(
                        margin: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20,
                              offset: Offset(0, -5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(24, 50, 24, 40), // Top 50 para dejar espacio al oso
                            children: [
                              _buildTermsText(),
                              const SizedBox(height: 20),

                              // Mensaje final (estético)
                              Center(
                                child: Text(
                                  "Fin del documento",
                                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // El Icono del Osito (Flotando arriba)
                      Positioned(
                        top: 0,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          // Aquí puedes poner tu imagen real: Image.asset('assets/images/logo.png')
                          child: const Icon(Icons.pets, size: 40, color: AppColors.primaryButton),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método auxiliar para el texto largo
  Widget _buildTermsText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "TÉRMINOS Y CONDICIONES DE USO",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        const Text(
          "Última actualización: 01 de diciembre de 2025",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 24),

        // Texto del cuerpo
        RichText(
          textAlign: TextAlign.justify,
          text: const TextSpan(
            style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.5, fontFamily: 'Inter'),
            children: [
              TextSpan(text: "Bienvenido a Osito Polar. Estos Términos y Condiciones rigen el uso de nuestra aplicación móvil y los servicios relacionados. Al descargar, instalar o utilizar la aplicación, usted acepta estar vinculado por estos términos. Si no está de acuerdo con alguna parte de los términos, no podrá acceder al servicio.\n\n"),
              TextSpan(text: "La aplicación es operada por CoolingWorks, con sede en Lima, Perú.\n\n"),

              TextSpan(text: "1. Cuentas de Usuario\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              TextSpan(text: "Para acceder a ciertas funciones de la aplicación, es posible que deba crear una cuenta. Usted es responsable de mantener la confidencialidad de su cuenta y contraseña, y acepta la responsabilidad de todas las actividades que ocurran bajo su cuenta.\n\nDebe proporcionar información precisa y completa al registrarse.\n\nNos reservamos el derecho de cancelar cuentas, editar o eliminar contenido a nuestra entera discreción.\n\n"),

              TextSpan(text: "2. Contenido Generado por el Usuario\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              TextSpan(text: "Nuestra aplicación permite a los usuarios crear, cargar, publicar y almacenar contenido, como texto e imágenes (\"Contenido del Usuario\").\n\nUsted conserva los derechos de propiedad sobre el contenido que crea.\n\nAl publicar contenido en Osito Polar, nos otorga una licencia mundial, no exclusiva y libre de regalías para usar, reproducir y mostrar dicho contenido en relación con el funcionamiento del servicio.\n\nUsted acepta no publicar contenido que sea ilegal, ofensivo o que infrinja los derechos de terceros.\n\n"),
              TextSpan(text: "Infracción de Derechos de Autor (DMCA): ", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "Si cree que su trabajo ha sido copiado de una manera que constituye una infracción de derechos de autor, por favor contacte a nuestro Agente de Derechos de Autor en: u202317442@upc.edu.pe.\n\n"),

              TextSpan(text: "3. Propiedad Intelectual\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              TextSpan(text: "El servicio y su contenido original (excluyendo el Contenido del Usuario), características y funcionalidad (incluyendo, pero no limitado a: logotipos, diseño visual, marcas comerciales y código) son y seguirán siendo propiedad exclusiva de CoolingWorks. No se permite el uso de nuestras marcas comerciales sin nuestro consentimiento previo por escrito.\n\n"),

              TextSpan(text: "4. Compras y Pagos\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              TextSpan(text: "4.1 Compras dentro de la aplicación (In-app purchases): ", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "La aplicación puede ofrecer la compra de bienes virtuales, ítems o servicios a través de pagos únicos. Todas las compras son definitivas y no reembolsables, excepto cuando la ley lo exija.\n\n"),
              TextSpan(text: "4.2 Suscripciones: ", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "Algunas partes del servicio están disponibles solo mediante una suscripción paga.\n\n"),
              TextSpan(text: "Facturación: ", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "Se le facturará por adelantado de forma recurrente y periódica (por ejemplo, mensual o anualmente).\n\n"),
              TextSpan(text: "Renovación: ", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "Su suscripción se renovará automáticamente al final de cada ciclo de facturación a menos que usted la cancele o CoolingWorks la cancele.\n\n"),
              TextSpan(text: "Sin Prueba Gratuita: ", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "Actualmente no ofrecemos pruebas gratuitas para nuestros planes de suscripción. El cargo se realizará inmediatamente al momento de suscribirse.\n\n"),

              TextSpan(text: "5. Política de Comentarios (Feedback)\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              TextSpan(text: "Si usted nos envía comentarios, ideas o sugerencias sobre cómo mejorar Osito Polar:\n\nAcepta que podemos utilizar dichos comentarios para cualquier propósito (comercial o de otro tipo) sin ninguna obligación de compensarlo o darle crédito.\n\n"),

              TextSpan(text: "6. Enlaces a Terceros\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              TextSpan(text: "Nuestro servicio puede contener enlaces a sitios web o servicios de terceros que no son propiedad ni están controlados por CoolingWorks. No tenemos control ni asumimos responsabilidad por el contenido, las políticas de privacidad o las prácticas de sitios web o servicios de terceros.\n\n"),

              TextSpan(text: "7. Limitación de Responsabilidad\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              TextSpan(text: "En la medida máxima permitida por la ley aplicable, CoolingWorks no será responsable de ningún daño indirecto, incidental, especial, consecuente o punitivo, incluyendo, sin limitación, pérdida de beneficios, datos, uso, buena voluntad u otras pérdidas intangibles, resultantes de su acceso o uso o la imposibilidad de acceder o usar el servicio.\n\n"),

              TextSpan(text: "8. Ley Aplicable\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              TextSpan(text: "Estos Términos se regirán e interpretarán de acuerdo con las leyes de Perú, sin tener en cuenta sus disposiciones sobre conflictos de leyes.\n\n"),

              TextSpan(text: "9. Contacto\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              TextSpan(text: "Si tiene alguna pregunta sobre estos Términos y Condiciones, puede contactarnos:\n\nPor correo electrónico: u202317442@upc.edu.pe"),
            ],
          ),
        ),
      ],
    );
  }
}