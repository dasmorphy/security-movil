import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class BasicServicesSection extends StatelessWidget {
  const BasicServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      padding: const EdgeInsetsGeometry.only(left: 15, right: 15, bottom: 20, top: 0),
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
            mainAxisSpacing: 10,
            crossAxisSpacing: 11,
            childAspectRatio: 0.9,
            children: const [
              BasicServiceCard(
                iconImage: 'register_form',
                label: 'Bitácora de Ingreso',
                childWidget: DepatureReportForm(),
              ),
              BasicServiceCard(
                iconImage: 'out_form',
                label: 'Bitácora de salida',
                childWidget: ExitReportForm(),
              ),
              BasicServiceCard(
                iconImage: 'security_cam',
                label: 'Monitoreo de Cámaras',
                childWidget: DepatureReportForm(),
              ),
              BasicServiceCard(
                iconImage: 'security_cam',
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
            physics: const BouncingScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 7,
            childAspectRatio: 0.9,
            children: const [
              BasicServiceCard(
                iconImage: 'report_pdf',
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
