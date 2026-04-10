import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewDispatchScreen extends ConsumerStatefulWidget  {

  static const name = 'new-dispatch-screen';

  const NewDispatchScreen({super.key});

  @override
  ConsumerState<NewDispatchScreen> createState() => _NewDispatchScreenState();
}

class _NewDispatchScreenState extends ConsumerState<NewDispatchScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    ref.read(getHistoryEntryAccess.notifier).load();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Nuevo despacho',),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        // bottom: false,
        child: 
              DispatchForm(
                onSubmit: (data) async {
                  return await ref
                    .read(dispatchProvider.notifier)
                    .saveDispatch(data);
                },
              ),
            
      ),
    );
  }
}
