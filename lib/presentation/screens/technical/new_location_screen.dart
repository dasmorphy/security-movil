import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewLocationScreen extends ConsumerStatefulWidget {
  static const name = 'new-location-screen';

  const NewLocationScreen({super.key});

  @override
  ConsumerState<NewLocationScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends ConsumerState<NewLocationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderOptionsProfile(headerTxt: "Registro localización"),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        // bottom: false,
        child: NewLocationForm(
          onSubmit: (data) async {
            return await ref
              .read(technicalRecordProvider.notifier)
              .saveLocationClient(data);
          },
        ),
      ),
    );
  }
}
