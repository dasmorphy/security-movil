import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/all_dispatch.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class UpdateStatusDispatchScreen extends ConsumerWidget {
  static const name = 'update-status-dispatch-screen';

  final AllDispatch dispatchData;

  const UpdateStatusDispatchScreen({super.key, required this.dispatchData});

  @override
  Widget build(BuildContext context,  WidgetRef ref) {
    return UpdateStatusDispatch(
      item: dispatchData
    );
  }
}
