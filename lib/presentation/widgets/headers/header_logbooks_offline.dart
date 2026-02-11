import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class HeaderLogbooksOffline extends ConsumerWidget {
  final String headerTxt;
  const HeaderLogbooksOffline({super.key, required this.headerTxt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final pendingAsync = ref.watch(pendingRequestsProvider);

    final canRetry = pendingAsync.maybeWhen(
      data: (pending) =>
        pending.isNotEmpty &&
        pending.any((raw) => raw['processing'] != true),
      orElse: () => false,
    );


    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => context.pop(),
                child: const Padding(
                  padding: EdgeInsets.all(7),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Text(
              headerTxt,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  if (canRetry) {
                    ref.read(syncPendingProvider.notifier).sync();
                  } else {
                    _showNoPendingDialog(context);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(7),
                  child: Icon(Icons.refresh, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNoPendingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const ShowDialogWidget(
        title: 'Nada para reintentar',
        content: 'No hay bitácoras pendientes de sincronizar.',
      ),
    );
  }

}
