import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/constants/environment.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/all_logbook.dart';
import 'package:zentinel/presentation/models/detail_log_label.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class BitacoraDetailModal extends ConsumerStatefulWidget {
  final AllLogbook item;

  const BitacoraDetailModal({super.key, required this.item});

  @override
  ConsumerState<BitacoraDetailModal> createState() => _BitacoraDetailModalState();
}

class _BitacoraDetailModalState extends ConsumerState<BitacoraDetailModal> {
  String _prettyKey(String key) {
    return key.replaceAll('_', ' ').splitMapJoin(RegExp(r'\w+'), onMatch: (m) {
      final s = m.group(0)!;
      return s[0].toUpperCase() + s.substring(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    const hiddenFields = {
      'updated_by',
      'group_business_id',
      'updated_at',
      'id_logbook_entry',
      'id_logbook_out',
      'id_sector',
      'category_id',
      'unity_id',
      'images_entry',
      'images_out'
    };

    final entries = widget.item
        .toJson()
        .entries
        .where((e) => !hiddenFields.contains(e.key))
        .toList();


    final images = (widget.item.imagesEntry?.isNotEmpty ?? false)
    ? widget.item.imagesEntry!
    : widget.item.imagesOut;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 40),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 24),
                Text(
                  'Detalle',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 420),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...entries.map((e) {
                        final key = e.key;
                        final value = e.value;

                        if (key == 'id' || key == 'id_logbook_entry') {
                          return const SizedBox.shrink();
                        }

                        String displayKey = detailLogLabels[key] ?? _prettyKey(key);
                        String displayValue;

                        if (value == null) {
                          displayValue = '—';
                        } else if (key.toLowerCase().contains('date') ||
                          key.toLowerCase().contains('created_at')) {
                          displayValue = formatDateDetails(value.toString());
                        }
                        
                        else {
                          displayValue = value.toString();
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  displayKey,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.white70,
                                      ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  displayValue,
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),


                      if (images != null && images.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Imágenes',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: images.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _openImageFullscreen(
                                  context, images, index),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  'http://st.telearseg.net${images[index]}',
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return Container(
                                      color: Colors.white10,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, _, __) => Container(
                                    color: Colors.white10,
                                    child: const Icon(
                                      Icons.broken_image_outlined,
                                      color: Colors.white30,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],


                    ]
                    
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            if (widget.item.status == 'Pendiente Salida')
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 36, 83, 168),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ExitReportForm(
                      preloadedData: widget.item,
                        onSubmit: (data) async {
                          return await ref
                            .read(saveOutLogbookProvider.notifier)
                            .saveLogbookOut(data);
                        },
                      ),
                    ),
                  );

                  // if (!context.mounted) return;

                  // context.go('/');
                  
                },
                child: const Text(
                  'Continuar',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 8),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF444444),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  void _openImageFullscreen(
      BuildContext context, List<dynamic> images, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImageViewer(images: images, initialIndex: initialIndex, baseUrl: Environments.baseUrl),
      ),
    );
  }
}