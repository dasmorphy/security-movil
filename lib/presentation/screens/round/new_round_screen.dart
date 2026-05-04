import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewRoundScreen extends ConsumerStatefulWidget  {

  static const name = 'new-round-screen';

  const NewRoundScreen({super.key});

  @override
  ConsumerState<NewRoundScreen> createState() => _NewRoundScreenState();
}

class _NewRoundScreenState extends ConsumerState<NewRoundScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Registro de ronda',),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        child: 
          NewRoundForm(
            onSubmit: (data) async {
              return await ref
                .read(roundProvider.notifier)
                .saveRound(data);
            },
          ),
            
      ),
    );
  }
}
