import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/forms/exit_report_form.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class BasicServicesSection extends StatelessWidget {
  const BasicServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
          
          // Grid de servicios
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 7,
            childAspectRatio: 0.9,
            children: const [
              BasicServiceCard(
                icon: Icons.no_crash_rounded,
                label: 'Bitácora de Ingreso',
                childWidget: DepatureReportForm(),
              ),
              BasicServiceCard(
                icon: Icons.document_scanner_sharp,
                label: 'Bitácora de salida',
                childWidget: ExitReportForm(),
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

          const SizedBox(height: 25,),

          const Text(
            'Reportes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Grid de servicios
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 7,
            childAspectRatio: 0.9,
            children: const [
              BasicServiceCard(
                icon: Icons.text_snippet,
                label: 'Reporte Totalizado',
                childWidget: TotalReport(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
