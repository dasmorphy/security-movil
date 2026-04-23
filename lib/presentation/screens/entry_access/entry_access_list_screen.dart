import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EntryAccessListScreen extends ConsumerStatefulWidget  {

  static const name = 'entry-access-list-screen';

  const EntryAccessListScreen({super.key});

  @override
  ConsumerState<EntryAccessListScreen> createState() => _EntryAccessListScreenState();
}

class _EntryAccessListScreenState extends ConsumerState<EntryAccessListScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    ref.read(getHistoryEntryAccess.notifier).load();
  }
  

  @override
  Widget build(BuildContext context) {
    final historyEntryAccess = ref.watch(getHistoryEntryAccess);
    final filtered = historyEntryAccess.where((item) {
      final text = searchText.toLowerCase();

      final areaName = (item.areaName).toLowerCase();
      final dni = (item.dni).toLowerCase();
      final namesVisit = (item.namesVisit).toLowerCase();

      return namesVisit.contains(text) || areaName.contains(text) || dni.contains(text);
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Control de acceso',),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        // bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SearchBarWidget(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),
              const SizedBox(height: 30,),
              Expanded(child: EntryAccessList(items: filtered)),
            ],
          )
        ),
      ),
    );
  }
}
