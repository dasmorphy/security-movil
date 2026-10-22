import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class HeaderOffline extends ConsumerWidget {
  final String headerTxt;
  final AsyncValue<List<Map<String, dynamic>>> pendingAsync;
  final Future<void> Function() sync;
  const HeaderOffline({super.key, required this.headerTxt, required this.pendingAsync, required this.sync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final canRetry = pendingAsync.maybeWhen(
      data: (pending) =>
        pending.isNotEmpty &&
        pending.any((raw) => raw['processing'] != true),
      orElse: () => false,
    );


    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => context.pop(),
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: context.colors.icon,
                      ),
                    ),
                  ),
                ),
          
                Text(
                  headerTxt,
                  style: TextStyle(
                    fontSize: 16,
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      if (canRetry) {
                        sync(); // antes era `sync;` (no disparaba nada)
                      } else {
                        _showNoPendingDialog(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Icon(Icons.refresh, color: context.colors.icon),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNoPendingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const ShowDialogWidget(
        title: 'Nada para reintentar',
        content: 'No hay registros pendientes de sincronizar.',
      ),
    );
  }

}
