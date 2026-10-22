import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/constants/permissions.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServicesBiomar extends ConsumerStatefulWidget {
  const ServicesBiomar({super.key});

  @override
  ConsumerState<ServicesBiomar> createState() =>
      _ServicesBiomarState();
}

class _ServicesBiomarState extends ConsumerState<ServicesBiomar> {
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

    final hasDispatchOptions =
      userData.hasPermission(Permissions.nuevoDespacho) ||
      userData.hasPermission(Permissions.nuevoProductoInterno);

    final hasAccessOptions = userData.hasPermission(Permissions.verIngresosBiomar);

    final hasAnyOption = hasDispatchOptions || hasAccessOptions;

    if (!hasAnyOption) {
      return Center(
        child: Text(
          'No tiene permisos para acceder a ningún módulo',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 16,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsetsGeometry.only(left: 15, right: 15, bottom: 0, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (userData.hasPermission(Permissions.nuevoDespacho) || userData.hasPermission(Permissions.nuevoProductoInterno))...[
            Text(
              'Control Despachos',
              style: TextStyle(
                color: context.colors.textPrimary,
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
                if (userData.hasPermission(Permissions.nuevoDespacho))
                  BasicServiceCard(
                      iconImage: 'iconentrada',
                      label: 'Materia prima',
                      onTap: () => context.push('/new-dispatch')
                    ),
                if (userData.hasPermission(Permissions.nuevoProductoInterno))
                  BasicServiceCard(
                    iconImage: 'iconentrada',
                    label: 'Producto terminado',
                    onTap: () => context.push('/new-dispatch', extra: true)
                  ),

              ],
            ),
          ],

          if (userData.hasPermission(Permissions.verIngresosBiomar))...[
            const SizedBox(height: 25),
            Text(
              'Control de accesos',
              style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            GridView.count(
              padding: const EdgeInsetsGeometry.only(top: 10),
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 11,
              childAspectRatio: 0.9,
              children: [
                if (userData.hasPermission(Permissions.nuevoIngresoBiomar))
                  BasicServiceCard(
                    iconImage: 'iconregistro',
                    label: 'Ingresos',
                    childWidget: BiomarEntryReportForm(
                      onSubmit: (data) async {
                      return await ref
                        .read(dispatchProvider.notifier)
                        .saveEntry(data);
                    },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
