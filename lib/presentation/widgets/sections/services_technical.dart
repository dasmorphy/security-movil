import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/constants/permissions.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServicesTechnical extends ConsumerStatefulWidget {
  const ServicesTechnical({super.key});

  @override
  ConsumerState<ServicesTechnical> createState() =>
      _ServicesTechnicalState();
}

class _ServicesTechnicalState extends ConsumerState<ServicesTechnical> {
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
      padding: const EdgeInsetsGeometry.only(left: 15, right: 15, bottom: 20, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (userData.hasPermission(Permissions.verProyectos))...[
            const Text(
              'Técnicos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 11,
              childAspectRatio: 0.9,
              children: [
                if (userData.hasPermission(Permissions.verProyectos))
                  BasicServiceCard(
                      iconImage: 'iconentrada',
                      label: 'Proyectos',
                      onTap: () => context.push('/list-task-technical')
                    ),

                if (userData.hasPermission(Permissions.nuevoProyecto))
                  BasicServiceCard(
                      iconImage: 'iconentrada',
                      label: 'Nuevo proyecto',
                      onTap: () => context.push('/new-project-technical')
                    ),
                if (userData.hasPermission(Permissions.verSoportesTecnicos))
                  BasicServiceCard(
                      iconImage: 'iconentrada',
                      label: 'Soportes',
                      onTap: () => context.push('/list-task-technical', extra: {
                        'is_support': true
                      })
                    ),
                if (userData.hasPermission(Permissions.nuevoSoporteTecnico))
                  BasicServiceCard(
                    iconImage: 'iconentrada',
                    label: 'Nuevo soporte',
                    onTap: () => context.push('/new-project-technical', extra: {
                      'is_support': true
                    })
                  ),

                if (userData.hasPermission(Permissions.nuevaLocalizacion))
                  BasicServiceCard(
                    iconImage: 'iconentrada',
                    label: 'Nueva localización',
                    onTap: () => context.push('/new-location')
                  ),

                if (userData.hasPermission(Permissions.nuevoProducto))
                  BasicServiceCard(
                    iconImage: 'iconentrada',
                    label: 'Nuevo producto',
                    onTap: () => context.push('/new-product')
                  ),
                  
              ],
            ),
          ],
        ],
      ),
    );
  }
}
