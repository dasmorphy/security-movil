import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/headers/header_options_profile.dart';
import 'package:zentinel/presentation/widgets/shared/search_bar.dart';
import 'package:zentinel/presentation/widgets/technical/technical_record_tile.dart';

class TechnicalRecordListScreen extends ConsumerStatefulWidget {
  static const name = 'technical-record-list-screen';

  const TechnicalRecordListScreen({super.key});

  @override
  ConsumerState<TechnicalRecordListScreen> createState() =>
      _TechnicalRecordListScreenState();
}

class _TechnicalRecordListScreenState
    extends ConsumerState<TechnicalRecordListScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userSessionProvider).value;
      if (user != null) {
        ref
        .read(getTechnicalRecord.notifier)
        .load(filters: {'user': user.user});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(getTechnicalRecord);
    final normalizedSearch = searchText.trim().toLowerCase();
    final filteredRecords = records.where((record) {
      if (normalizedSearch.isEmpty) return true;

      return record.taskCode.toLowerCase().contains(normalizedSearch) ||
          record.clientName.toLowerCase().contains(normalizedSearch) ||
          record.locationName.toLowerCase().contains(normalizedSearch) ||
          record.createdBy.toLowerCase().contains(normalizedSearch) ||
          record.status.toLowerCase().contains(normalizedSearch);
    }).toList();

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderOptionsProfile(headerTxt: 'Registros técnicos'),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SearchBarWidget(
                onChanged: (value) => setState(() => searchText = value),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: filteredRecords.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay registros',
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          final user = ref.read(userSessionProvider).value;
                          if (user != null) {
                            await ref
                                .read(getTechnicalRecord.notifier)
                                .load(filters: {'user': user.user});
                          }
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: filteredRecords.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: TechnicalRecordTile(
                              item: filteredRecords[index],
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
