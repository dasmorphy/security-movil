import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewBlackListScreen extends ConsumerStatefulWidget {
  static const name = 'new-black-list-screen';

  const NewBlackListScreen({super.key});

  @override
  ConsumerState<NewBlackListScreen> createState() => _NewBlackListScreenState();
}

class _NewBlackListScreenState extends ConsumerState<NewBlackListScreen> {
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
        child: HeaderOptionsProfile(headerTxt: 'Nuevo registro'),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        // bottom: false,
        child: BlackListForm(
          onSubmit: (data) async {
            return await ref
              .read(postApiResponseProvider.notifier)
              .saveDriverBlacklist(data);
          },
        ),
      ),
    );
  }
}
