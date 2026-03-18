import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogbookListScreen extends ConsumerStatefulWidget  {

  static const name = 'logbook-list-screen';

  const LogbookListScreen({super.key});

  @override
  ConsumerState<LogbookListScreen> createState() => _LogbookListScreenState();
}

class _LogbookListScreenState extends ConsumerState<LogbookListScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    ref.read(getHistoryLogbooks.notifier).load();
  }
  

  @override
  Widget build(BuildContext context) {
    final historyLogbooks = ref.watch(getHistoryLogbooks);
    final filtered = historyLogbooks.where((item) {
      final text = searchText.toLowerCase();

      final shippingGuide = (item.shippingGuide ?? '').toLowerCase();
      final truckLicense = (item.truckLicense).toLowerCase();
      final nameDriver = (item.nameDriver ?? '').toLowerCase();

      return nameDriver.contains(text) || shippingGuide.contains(text) || truckLicense.contains(text);
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Bitácoras recientes',),
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
              Expanded(child: LogbooksList(items: filtered)),
            ],
          )
        ),
      ),
    );
  }
}