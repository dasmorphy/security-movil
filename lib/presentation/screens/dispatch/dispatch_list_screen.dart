import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DispatchListScreen extends ConsumerStatefulWidget  {

  static const name = 'dispatch-list-screen';

  const DispatchListScreen({super.key});

  @override
  ConsumerState<DispatchListScreen> createState() => _DispatchListScreenState();
}

class _DispatchListScreenState extends ConsumerState<DispatchListScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    ref.read(getHistoryDispatch.notifier).load();
  }
  

  @override
  Widget build(BuildContext context) {
    final historyDispatch = ref.watch(getHistoryDispatch);
    final filtered = historyDispatch.where((item) {
      final text = searchText.toLowerCase();

      final codeSku = (item.codeSku).toLowerCase();
      final truckLicense = (item.truckLicense).toLowerCase();
      final nameDriver = (item.driver).toLowerCase();

      return nameDriver.contains(text) || codeSku.contains(text) || truckLicense.contains(text);
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Despachos recientes',),
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
              Expanded(child: DispatchList(items: filtered)),
            ],
          )
        ),
      ),
    );
  }
}