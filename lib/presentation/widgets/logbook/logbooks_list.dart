import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class LogbooksList extends ConsumerStatefulWidget {
  final List<dynamic> items;
  final int? limit;

  const LogbooksList({
    super.key,
    required this.items,
    this.limit = 15,
  });

  @override
  ConsumerState<LogbooksList> createState() => LogbooksListState();
}

class LogbooksListState extends ConsumerState<LogbooksList> {
  
  void _openModal(BuildContext context, Widget childWidget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) {
        return AnimatedModal(child: childWidget);
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final items = widget.limit != null
      ? widget.items.take(widget.limit!).toList()
      : widget.items;

    if (widget.items.isEmpty) {
      return const Center(
        child: Text(
          'No hay registros',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            // shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
          
              final item = items[index];
          
              final isEntry = item.idLogbookEntry != null;
              final typeText = isEntry ? 'ingreso' : 'salida';
          
              final createdBy = item.nameUser ?? 'Sin usuario';
              final groupName = item.groupName ?? 'Sin grupo';
          
              final description = 'Bitácora de $typeText en $groupName';
          
              final formattedDate = formatDate(item.createdAt);
          
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () =>
                      _openModal(context, BitacoraDetailModal(item: item)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icono
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
          
                      // Información
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              createdBy,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: const Color.fromARGB(255, 180, 180, 180),
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              formattedDate,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: const Color.fromARGB(255, 180, 180, 180),
                                  ),
                            ),

                            const SizedBox(height: 2),

                            Chip(
                              label: Text(item.status) ,
                              backgroundColor: item.status == 'Finalizado' ? Color.fromARGB(255, 34, 197, 94) : const Color.fromARGB(255, 224, 157, 49),
                              padding: EdgeInsets.zero,
                              labelStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),

                          ],
                        ),
                      ),
          
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 10,),
            
        Text('Ver más registros', style: TextStyle(color: Colors.white, fontSize: 15),),
        
        SizedBox(height: 10,),

      ],
    );
  }
}