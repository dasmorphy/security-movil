import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/constants/permissions.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServicesUrb extends ConsumerStatefulWidget {
  const ServicesUrb({super.key});

  @override
  ConsumerState<ServicesUrb> createState() =>
      _ServicesUrbState();
}

class _ServicesUrbState extends ConsumerState<ServicesUrb> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(userSessionProvider);

    if (!authState.hasValue || authState.value == null) {
      return const SizedBox.shrink();
    }

    final userData = authState.value!;

    return Padding(
      padding: const EdgeInsetsGeometry.only(left: 15, right: 15, bottom: 20, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Control Urbanizaciones',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 11,
            childAspectRatio: 0.9,
            children: [
              if (userData.hasPermission(Permissions.nuevoDespacho))
                BasicServiceCard(
                  iconImage: 'iconentrada',
                  label: 'Nuevo registro',
                  onTap: () => context.push('/new-round-register')
                ),

            ],
          ),     
        ],
      ),
    );
  }
}
