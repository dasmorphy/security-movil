import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/entry_access_cards.dart';
import 'package:zentinel/domain/entities/entry_access_control.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

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

    final materials = entryAccessData.materials.map((material) {
      return MaterialEntry(
        id: material.idMaterial,
        name: material.name,
        quantity: material.quantity,
        otherMaterial: material.otherMaterial
      );
    }).toList();

    return FinishEntryForm(
      entryAccessHeader: dispatchHeader,
      materials: materials,
      onSubmit: (data) async {
        print('Datos de recepción: $data');
        final authState = ref.watch(userSessionProvider);
        final userData = authState.value!;
        data['user'] = userData.user;
        final updateEntryProvider = ref.read(dispatchProvider.notifier);
        return await updateEntryProvider.updateEntry(data);
      },
      onBackPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
