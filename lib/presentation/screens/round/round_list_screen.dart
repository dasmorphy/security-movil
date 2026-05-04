import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoundListScreen extends ConsumerStatefulWidget  {

  static const name = 'round-list-screen';

  const RoundListScreen({super.key});

  @override
  ConsumerState<RoundListScreen> createState() => _RoundListScreenState();
}

class _RoundListScreenState extends ConsumerState<RoundListScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    ref.read(getHistoryRounds.notifier).load();
  }
  

  @override
  Widget build(BuildContext context) {
    final historyRounds = ref.watch(getHistoryRounds);
    final filtered = historyRounds.where((item) {
      final text = searchText.toLowerCase();

      final pool = (item.pool ?? '').toLowerCase();
      final nameSector = (item.nameSector ?? '').toLowerCase();

      return pool.contains(text) || nameSector.contains(text);
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Rondas recientes',),
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
              Expanded(child: RoundsList(items: filtered)),
            ],
          )
        ),
      ),
    );
  }
}