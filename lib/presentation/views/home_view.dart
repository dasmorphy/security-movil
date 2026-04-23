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
  }

  void initProvidersByBusiness(User? userData) {
    if (userData != null) {
      if (userData.attributes['id_business'] == 1 || selectedBusiness == "1") {
        ref.read(getAllCategories.notifier).load();
        ref.read(getGroupBusinessByIdBusiness.notifier).load();
        ref.read(getAllUnitiesWeight.notifier).load();
        ref.read(getAllAuthorized.notifier).load();
        ref.read(getAllDestinyIntern.notifier).load();
        ref.read(getHistoryLogbooks.notifier).load();
      } else if (userData.attributes['id_business'] == 2 ||
          selectedBusiness == "2") {
        ref.read(getAllDestinyIntern.notifier).load();
        ref.read(getAreasVisit.notifier).load();
        ref.read(getMaterials.notifier).load();
        ref.read(getStaffCharge.notifier).load();
        ref.read(getAllVehicleTypes.notifier).load();
        ref.read(getDispatchStatus.notifier).load();
        ref.read(getAllDispatchProducts.notifier).load();
        ref.read(getHistoryDispatch.notifier).load();
        ref.read(getHistoryEntryAccess.notifier).load();
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
                if (idBusiness == 3)
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
                  ref
                      .watch(graphDispatchProvider)
                      .when(
                        data: (data) => Column(
                          children: [
                            ShipmentDispatch(data: data),
                            const SizedBox(height: 20),
                            DiscrepancyDonutWidget(data: data),
                          ],
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => const Text('Error cargando datos'),
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
                  ref
                      .watch(graphLogbookProvider)
                      .when(
                        data: (data) =>
                            Column(children: [DonutExpalsa(data: data)]),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => const Text('Error cargando datos'),
                      ),
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
