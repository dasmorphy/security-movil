import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';

class BitacoraDetailModal extends StatelessWidget {
  final Map<String, dynamic> item;

  const BitacoraDetailModal({super.key, required this.item});

  String _prettyKey(String key) {
    return key.replaceAll('_', ' ').splitMapJoin(RegExp(r'\w+'), onMatch: (m) {
      final s = m.group(0)!;
      return s[0].toUpperCase() + s.substring(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final entries = item.entries.toList();

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 40),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        // decoration: const BoxDecoration(
        //   color: Color(0xFF2B2B2B),
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(20),
        //     topRight: Radius.circular(20),
        //   ),
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                Text(
                  'Detalle',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // If there's a common fields like created_by or group_name show them prominently
            // if (item['created_by'] != null)
            //   Text(
            //     item['created_by'].toString(),
            //     textAlign: TextAlign.center,
            //     style: Theme.of(context).textTheme.titleMedium?.copyWith(
            //           color: Colors.white,
            //           fontWeight: FontWeight.w600,
            //         ),
            //   ),
            if (item['group_name'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 12),
                child: Text(
                  item['group_name'].toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ),

            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 420),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: entries.map((e) {
                      final key = e.key;
                      final value = e.value;

                      if (key == 'id' || key == 'id_logbook_entry') {
                        return const SizedBox.shrink();
                      }

                      final Map<String, String> keyTranslations = {
                        'shipping_guide': 'Guía de remisión',
                        'quantity': 'Cantidad',
                        'weight': 'Peso',
                        'authorized_by': 'Autorizado por',
                        'observation': 'Observaciones',
                      };

                      String displayKey = keyTranslations[key] ?? _prettyKey(key);

                      String displayValue;
                      if (value == null) {
                        displayValue = '—';
                      } else if (
                        key.toLowerCase().contains('date') ||
                        key.toLowerCase().contains('created_at')
                      ) {
                        displayValue = formatDateDetails(value.toString());
                      } else {
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
                    }).toList(),
                  ),
                ),
              ),
            ),


            const SizedBox(height: 58),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF444444),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
