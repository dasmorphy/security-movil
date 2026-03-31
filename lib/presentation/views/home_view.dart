import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    ref.read(getAllDispatchProducts.notifier).load();
    ref.read(getHistoryLogbooks.notifier).load();
    ref.read(getHistoryDispatch.notifier).load();

    //Se llama los catalogos desde el home para escenarios offline
    // ref.read(getAllCategories.notifier).load();
    // ref.read(getGroupBusinessByIdBusiness.notifier).load();
    // ref.read(getAllUnitiesWeight.notifier).load();
    // ref.read(getAllAuthorized.notifier).load();
    ref.read(getAllDestinyIntern.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const VideoHeader(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // Bitácoras Recientes
                RecentListHome(
                  title: 'Bitácoras recientes',
                  routeLink: '/list-logbooks',
                  childListBuild: const ItemRecentLogbook(),
                ),

                RecentListHome(
                  title: 'Despachos recientes',
                  routeLink: '/list-logbooks',
                  childListBuild: const ItemRecentDispatch(),
                ),

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
