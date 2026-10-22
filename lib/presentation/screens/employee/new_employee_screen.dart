import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewEmployeeScreen extends ConsumerStatefulWidget {
  static const name = 'new-employee-screen';

  const NewEmployeeScreen({super.key});

  @override
  ConsumerState<NewEmployeeScreen> createState() => _NewEmployeeScreenState();
}

class _NewEmployeeScreenState extends ConsumerState<NewEmployeeScreen> {
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
        child: HeaderOptionsProfile(headerTxt: 'Nuevo personal'),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: context.colors.card,
      body: SafeArea(
        top: false,
        // bottom: false,
        child: EmployeeInternForm(
          onSubmit: (data) async {
            return await ref
              .read(postApiResponseProvider.notifier)
              .saveEmployeeIntern(data);
          },
        ),
      ),
    );
  }
}
