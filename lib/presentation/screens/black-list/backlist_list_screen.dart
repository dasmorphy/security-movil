import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BacklistListScreen extends ConsumerStatefulWidget  {

  static const name = 'list-blacklist-screen';

  const BacklistListScreen({super.key});

  @override
  ConsumerState<BacklistListScreen> createState() => _BacklistListScreenState();
}

class _BacklistListScreenState extends ConsumerState<BacklistListScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    ref.read(getBlacklistDriver.notifier).load();
  }
  

  @override
  Widget build(BuildContext context) {
    final historyDispatch = ref.watch(getBlacklistDriver);
    final filtered = historyDispatch.where((item) {
      final text = searchText.toLowerCase();

      final dni = (item.dni).toLowerCase();
      final fulllNames = (item.fullNames).toLowerCase();

      return dni.contains(text) || fulllNames.contains(text);
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Lista negra',),
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
              Expanded(child: ListBlacklistDriver(items: filtered)),
            ],
          )
        ),
      ),
    );
  }
}