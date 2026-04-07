import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/entry_access_cards.dart';
import 'package:zentinel/domain/entities/entry_access_control.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/forms/reception_confirmation_form.dart';

class FinishEntryAccessScreen extends ConsumerWidget {
  static const name = 'finish-entry-access-screen';

  final EntryAccessControl entryAccessData;

  const FinishEntryAccessScreen({super.key, required this.entryAccessData});

  @override
  Widget build(BuildContext context,  WidgetRef ref) {
    final dispatchHeader = EntryHeader(
      entryAccessId: entryAccessData.idAccessControl,
      dni: entryAccessData.dni,
      nameVisit: entryAccessData.namesVisit,
      areaVisit: entryAccessData.areaName,
      status: entryAccessData.status,
      statusColor: getStatusColorEntryAccess(entryAccessData.status),
    );

    final products = entryAccessData..map((product) {
      return MaterialEntry(
        id: product.idProduct,
        productName: product.name,
        status: 'CORRECTO',
        expectedQty: product.quantity,
        receivedQty: product.quantity,
        commentary: '',
        hasDiscrepancy: false,
      );
    }).toList();

    return ReceptionConfirmationForm(
      dispatchData: dispatchHeader,
      products: products,
      onSubmit: (data) async {
        print('Datos de recepción: $data');
        final authState = ref.watch(userSessionProvider);
        final userData = authState.value!;
        data['user'] = userData.user;
        final saveReceptionProvider = ref.read(dispatchProvider.notifier);
        return await saveReceptionProvider.saveReception(data);
      },
      onBackPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
