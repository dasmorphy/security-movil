import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/constants/permissions.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasicServicesSection extends ConsumerStatefulWidget {
  const BasicServicesSection({super.key});

  @override
  ConsumerState<BasicServicesSection> createState() =>
      _BasicServicesStionState();
}

class _BasicServicesStionState extends ConsumerState<BasicServicesSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(userSessionProvider);

    if (!authState.hasValue || authState.value == null) {
      return const SizedBox.shrink();
    }

    final userData = authState.value!;

    return Padding(
      padding: const EdgeInsetsGeometry.only(left: 15, right: 15, bottom: 0, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Servicios básicos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          GridView.count(
            padding: const EdgeInsetsGeometry.only(top: 10),
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 11,
            childAspectRatio: 0.9,
            children: [
              if (userData.hasPermission(Permissions.nuevaBitacoraIngreso))
                BasicServiceCard(
                  iconImage: 'iconentrada',
                  label: 'Bitácora de Ingreso',
                  childWidget: DepatureReportForm(
                    onSubmit: (data) async {
                      return await ref
                          .read(saveDepatureReportProvider.notifier)
                          .saveLogbookEntry(data);
                    },
                  ),
                ),

              if (userData.hasPermission(Permissions.nuevaBitacoraSalida))
                BasicServiceCard(
                  iconImage: 'iconsalida',
                  label: 'Bitácora de salida',
                  childWidget: ExitReportForm(
                    onSubmit: (data) async {
                      return await ref
                          .read(saveOutLogbookProvider.notifier)
                          .saveLogbookOut(data);
                    },
                  ),
                ),

              if (userData.hasPermission(Permissions.verPersonalInterno))
                BasicServiceCard(
                  iconImage: 'iconsalida',
                  label: 'Listado de personal interno',
                  onTap: () => context.push('/list-employee-intern')
                ),
              
              if (userData.hasPermission(Permissions.nuevoPersonalInterno))
                BasicServiceCard(
                  iconImage: 'iconsalida',
                  label: 'Nuevo personal interno',
                  onTap: () => context.push('/new-employee')
                ),
            ],
          ),

          const SizedBox(height: 18),

          if (userData.hasPermission(Permissions.listaReportes) || userData.hasPermission(Permissions.generarReportes))
            const Text(
              'Lista negra',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (userData.hasPermission(Permissions.listaReportes) || userData.hasPermission(Permissions.generarReportes))...[
              GridView.count(
                padding: const EdgeInsetsGeometry.only(top: 10),
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 11,
                childAspectRatio: 0.9,
                children: [
                  if (userData.hasPermission(Permissions.nuevaBitacoraIngreso))
                    BasicServiceCard(
                      iconImage: 'iconsalida',
                      label: 'Lista negra',
                      onTap: () => context.push('/new-employee')
                    ),

                    BasicServiceCard(
                      iconImage: 'iconsalida',
                      label: 'Nuevo lista negra',
                      onTap: () => context.push('/new-black-list')
                    ),
                  ],
              ),

              const SizedBox(height: 18),
            ],


          if (userData.hasPermission(Permissions.listaReportes) || userData.hasPermission(Permissions.generarReportes))...[
            const Text(
              'Balanceado y combustible',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (userData.hasPermission(Permissions.listaReportes) || userData.hasPermission(Permissions.generarReportes))...[
              GridView.count(
                padding: const EdgeInsetsGeometry.only(top: 10),
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 11,
                childAspectRatio: 0.9,
                children: [
                  if (userData.hasPermission(Permissions.nuevaBitacoraIngreso))
                    BasicServiceCard(
                      iconImage: 'iconsalida',
                      label: 'Lista órdenes',
                      onTap: () => context.push('/new-employee')
                    ),

                    BasicServiceCard(
                      iconImage: 'iconsalida',
                      label: 'Nueva orden',
                      onTap: () => context.push('/new-employee')
                    ),
                  ],
              ),
              const SizedBox(height: 18),
            ],

          ],

          // if (userData.hasPermission(Permissions.listaReportes) || userData.hasPermission(Permissions.generarReportes))
          //   const Text(
          //     'Reportes',
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 20,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),

          //   if (userData.hasPermission(Permissions.listaReportes) || userData.hasPermission(Permissions.generarReportes))
          //     GridView.count(
          //       crossAxisCount: 3,
          //       shrinkWrap: true,
          //       physics: const BouncingScrollPhysics(),
          //       mainAxisSpacing: 10,
          //       crossAxisSpacing: 11,
          //       childAspectRatio: 0.9,
          //       children: [
          //         if (userData.hasPermission(Permissions.listaReportes))
          //           BasicServiceCard(
          //             iconImage: 'iconregistro',
          //             label: 'Reporte Totalizado',
          //             childWidget: TotalReport(),
          //           ),
          //         if (userData.hasPermission(Permissions.generarReportes))
          //           BasicServiceCard(
          //             iconImage: 'iconregistro',
          //             label: 'Generar Reporte',
          //             onTap: () async {
          //               await ref.read(downloadReport.notifier).downloadReport();
          //             },
          //           ),
          //       ],
          //     ),
        ],
      ),
    );
  }
}
