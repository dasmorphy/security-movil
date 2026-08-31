import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/config/constants/permissions.dart';
import 'package:zentinel/domain/entities/user_session.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  //SINO SE ESPECIFICA NOTIFIER DEVUELVE EL ESTADO POR DEFECTO, ES DECIR EL VALOR DE ESE PROVIDER
  String selectedBusiness = '0';
  final List<Map<String, String>> optionsDashboard = [
    {"id": "1", "value": "Expalsa"},
    {"id": "2", "value": "Biomar"},
    {"id": "3", "value": "Técnicos"},
  ];

  @override
  void initState() {
    //En los metodos llmar el metodo read en los providers (flutter favorite)
    super.initState();

    final authState = ref.read(userSessionProvider);
    final userData = authState.value;
    if (userData!.role == 'admin_tlsg') {
      selectedBusiness = '1';
    }
    initProvidersByBusiness(userData);

    if (userData.hasPermission(Permissions.verRegistrosTecnicos)) {
      ref.read(getTechnicalRecord.notifier).load(filters: {"user": userData.user});
    }

    // if (userData.hasPermission(Permissions.verDashboardTecnico)) {
    //   ref.read(graphTechnicalProvider.notifier).load(filters: {});
    // }
  }

  void initProvidersByBusiness(User? userData) {
    if (userData != null) {
      if (userData.attributes['id_business'] == 1 || selectedBusiness == "1") {
        ref.read(getHistoryLogbooks.notifier).load();
        ref.read(graphLogbookProvider.notifier).load();
        ref
            .read(getEmployeeMovements.notifier)
            .load(
              filters: {
                "page": 1,
                "rows": 20,
                "type_movement": "TRANSFER",
                "group_business_id": userData.attributes['group_business'],
                "status_employee": "Autorizado",
              },
            );
      } else if (userData.attributes['id_business'] == 2 ||
          selectedBusiness == "2") {
        ref.read(getAllVehicleTypes.notifier).load();
        ref.read(getDispatchStatus.notifier).load();
        ref.read(getAllDispatchProducts.notifier).load();
        ref.read(getHistoryDispatch.notifier).load();
        ref.read(getHistoryEntryAccess.notifier).load();
        ref.read(graphDispatchProvider.notifier).load();
      } else if (userData.attributes['id_business'] == 3 ||
          selectedBusiness == "3") {
        ref.read(graphTechnicalProvider.notifier).load(filters: {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.read(userSessionProvider);

    if (!authState.hasValue || authState.value == null) {
      return const SizedBox.shrink();
    }

    final userData = authState.value!;
    final idBusiness = userData.attributes['id_business'];

    // Si es grupo 3 (admin_tlsg), usa el dropdown para decidir
    // Si es 1 o 2, fuerza directamente
    final effectiveBusiness = idBusiness == 3
        ? selectedBusiness
        : idBusiness.toString();

    return SingleChildScrollView(
      child: Column(
        children: [
          const VideoHeader(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown solo visible para grupo 3
                if (idBusiness == 3 && userData.role == 'admin_tlsg')
                  GlowDropdownFormField2<String>(
                    value: selectedBusiness,
                    items: [
                      ...optionsDashboard.map(
                        (c) => DropdownMenuItem(
                          value: c["id"].toString(),
                          child: Text(
                            c["value"]!,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 31, 30, 30),
                            ),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => selectedBusiness = v);
                        initProvidersByBusiness(userData);
                      }
                    },
                  ),

                /// =======================
                /// DASHBOARD BIOMAR
                /// =======================
                if (effectiveBusiness == "2" &&
                    (userData.role == "admin_tlsg" ||
                        userData.hasPermission(
                          Permissions.verDashboardBiomar,
                        ))) ...[
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      ShipmentDispatch(),
                      const SizedBox(height: 20),
                      DiscrepancyDonutWidget(),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],

                /// =======================
                /// DASHBOARD TECNICOS
                /// =======================
                
                if (effectiveBusiness == "3"  ||
                  userData.hasPermission(Permissions.verDashboardTecnico)
                )... [
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      CardsDashboardTech(),
                      const SizedBox(height: 20),
                      DonutTechnical(),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],

                /// =======================
                /// DASHBOARD EXPALSA
                /// =======================
                if (effectiveBusiness == "1" &&
                    (userData.role == "admin_tlsg" ||
                        userData.hasPermission(
                          Permissions.verDashboardExpalsa,
                        ))) ...[
                  const SizedBox(height: 10),
                  Column(children: [DonutExpalsa()]),
                  const SizedBox(height: 10),
                ],

                /// =======================
                /// BITÁCORAS
                /// =======================
                if (effectiveBusiness == "1" &&
                    (userData.role == "admin_tlsg" ||
                        userData.hasPermission(Permissions.verBitacoras))) ...[
                  const SizedBox(height: 10),
                  RecentListHome(
                    title: 'Bitácoras recientes',
                    routeLink: '/list-logbooks',
                    childListBuild: const ItemRecentLogbook(),
                  ),
                  const SizedBox(height: 30),
                ],

                /// =======================
                /// PERSONAL INTERNO
                /// =======================
                if (effectiveBusiness == "1" &&
                    (userData.role == "admin_tlsg" ||
                        userData.hasPermission(
                          Permissions.verMovimientosPersonalInterno,
                        ))) ...[
                  const SizedBox(height: 10),
                  RecentListHome(
                    title: 'Movimientos personal interno',
                    routeLink: '/list-employee-movements',
                    childListBuild: ItemRecentEmployeeMovement(
                      itememployeeMovements: ref.watch(getEmployeeMovements),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],

                if (userData.hasPermission(
                  Permissions.verRegistrosTecnicos,
                )) ...[
                  const SizedBox(height: 10),
                  RecentListHome(
                    title: 'Registros recientes',
                    routeLink: '/list-technical-records',
                    childListBuild: const ItemRecentTechnicalRecord(),
                  ),
                  const SizedBox(height: 30),
                ],

                /// =======================
                /// DESPACHOS
                /// =======================
                if (effectiveBusiness == "2" &&
                    (userData.role == "admin_tlsg" ||
                        userData.hasPermission(Permissions.verDespachos))) ...[
                  const SizedBox(height: 10),
                  RecentListHome(
                    title: 'Despachos recientes',
                    routeLink: '/list-dispatches',
                    childListBuild: const ItemRecentDispatch(),
                  ),
                  const SizedBox(height: 30),
                ],

                /// =======================
                /// INGRESOS
                /// =======================
                if (effectiveBusiness == "2" &&
                    (userData.role == "admin_tlsg" ||
                        userData.hasPermission(
                          Permissions.verIngresosBiomar,
                        ))) ...[
                  const SizedBox(height: 10),
                  RecentListHome(
                    title: 'Ingresos recientes',
                    routeLink: '/list-entry-access',
                    childListBuild: const ItemRecentEntry(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
