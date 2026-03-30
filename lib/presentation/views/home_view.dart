import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/utils/helper.dart';
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
    ref.read(getHistoryLogbooks.notifier).load();

    final authState = ref.read(userSessionProvider);
    final userData = authState.value;
    print('Usuario autenticado: $userData');

    ref.read(getAllVehicleTypes.notifier).load();
    ref.read(getAllDispatchProducts.notifier).load();

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
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Bitácoras recientes',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Column(
                            children: [
                              SizedBox(height: 4),
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => context.push('/list-logbooks'),
                                child: const Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ..._buildBitacoraItems(context),
                    ],
                  ),
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

  List<Widget> _buildBitacoraItems(BuildContext context) {
    final historyLogbooks = ref.watch(getHistoryLogbooks);
    final limitedList = historyLogbooks.take(5).toList();

    if (historyLogbooks.isEmpty) {
      return [
        const Text(
          'No hay registros',
          style: TextStyle(color: Colors.white54),
        )
      ];
    }

    return List.generate(limitedList.length, (index) {
      final item = limitedList[index];

      final isEntry = item.idLogbookEntry;
      final typeText = isEntry != null ? 'ingreso' : 'salida';

      final createdBy = item.nameUser;
      final groupName = item.groupName;

      final description = isEntry != null
          ? 'Bitácora de $typeText en $groupName'
          : 'Bitácora de $typeText en $groupName';

      final formattedDate = formatDate(item.createdAt);

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _openModal(context, BitacoraDetailModal(item: item)),
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icono check
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 4, 88, 99),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.edit_note_sharp,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            // Nombre y descripción
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    createdBy,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color.fromARGB(255, 180, 180, 180),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color.fromARGB(255, 180, 180, 180),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Chip(
                    label: Text(item.status),
                    backgroundColor: item.status == 'Finalizado'
                        ? const Color.fromARGB(255, 34, 197, 94)
                        : const Color.fromARGB(255, 224, 157, 49),
                    padding: EdgeInsets.zero,
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Chevron
            const Icon(Icons.chevron_right, color: Colors.white, size: 20),
          ],
        ),
        ),
      );
    });
  }

  void _openModal(BuildContext context, Widget childWidget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) {
        return AnimatedModal(child: childWidget);
      },
    );
  }
}
