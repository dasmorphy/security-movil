import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewDispatchScreen extends ConsumerStatefulWidget  {

  static const name = 'new-dispatch-screen';

  final dynamic isProductTerm;
  
  const NewDispatchScreen({super.key, this.isProductTerm = false});

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
    final String title = widget.isProductTerm == true ? 'Producto terminado' : 'Nuevo despacho'; 
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderOptionsProfile(headerTxt: title,),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: context.colors.card,
      body: SafeArea(
        top: false,
        // bottom: false,
        child: 
              DispatchForm(
                isProductTerm: widget.isProductTerm,
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
