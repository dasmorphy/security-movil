import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/config/constants/permissions.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  //SINO SE ESPECIFICA NOTIFIER DEVUELVE EL ESTADO POR DEFECTO, ES DECIR EL VALOR DE ESE PROVIDER

  @override
  void initState() {
    //En los metodos llmar el metodo read en los providers (flutter favorite)
    super.initState();

    final authState = ref.read(userSessionProvider);
    final userData = authState.value;
    print('Usuario autenticado: $userData');

    ref.read(getAllVehicleTypes.notifier).load();
    ref.read(getDispatchStatus.notifier).load();
    ref.read(getAllDispatchProducts.notifier).load();
    ref.read(getHistoryLogbooks.notifier).load();
    ref.read(getHistoryDispatch.notifier).load();
    ref.read(getHistoryEntryAccess.notifier).load();

    //Se llama los catalogos desde el home para escenarios offline
    // ref.read(getAllCategories.notifier).load();
    // ref.read(getGroupBusinessByIdBusiness.notifier).load();
    // ref.read(getAllUnitiesWeight.notifier).load();
    // ref.read(getAllAuthorized.notifier).load();
    ref.read(getAllDestinyIntern.notifier).load();
    ref.read(getAreasVisit.notifier).load();
    ref.read(getMaterials.notifier).load();
    ref.read(getStaffCharge.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.read(userSessionProvider);

    if (!authState.hasValue || authState.value == null) {
      return const SizedBox.shrink();
    }

    final userData = authState.value!;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          const VideoHeader(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (userData.hasPermission(Permissions.verBitacoras))...[
                  // Bitácoras Recientes
                  const SizedBox(height: 10),
                  RecentListHome(
                    title: 'Bitácoras recientes',
                    routeLink: '/list-logbooks',
                    childListBuild: const ItemRecentLogbook(),
                  ),
                ],

                if (userData.hasPermission(Permissions.verDespachos))...[
                  const SizedBox(height: 10),
                  RecentListHome(
                    title: 'Despachos recientes',
                    routeLink: '/list-dispatches',
                    childListBuild: const ItemRecentDispatch(),
                  ),
                ],

                if (userData.hasPermission(Permissions.verIngresosBiomar))...[
                  const SizedBox(height: 10),
                  RecentListHome(
                    title: 'Ingresos recientes',
                    routeLink: '/list-entry-access',
                    childListBuild: const ItemRecentEntry(),
                  ),
                ],
                

                const SizedBox(height: 15),
                // Publicidad
                PublicityCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
