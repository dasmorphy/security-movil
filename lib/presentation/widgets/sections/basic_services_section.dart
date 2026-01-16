import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class BasicServicesSection extends StatelessWidget {
  const BasicServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Text(
            'Servicios básicos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Grid de servicios
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.0,
            children: const [
              BasicServiceCard(
                icon: Icons.document_scanner_rounded,
                label: 'Reporte de Ingreso',
                childWidget: DepatureReportForm(),
              ),
              BasicServiceCard(
                icon: Icons.document_scanner_sharp,
                label: 'Reporte de salida',
                childWidget: DepatureReportForm(),
              ),
              BasicServiceCard(
                icon: Icons.video_camera_front,
                label: 'Monitoreo de Cámaras',
                childWidget: DepatureReportForm(),
              ),
              BasicServiceCard(
                icon: Icons.security,
                label: 'Seguridad',
                childWidget: DepatureReportForm(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
