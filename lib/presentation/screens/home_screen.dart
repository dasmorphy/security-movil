import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/constants/permissions.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/user_session.dart';
import 'package:zentinel/presentation/providers/logbook/logbook_provider.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/views/views.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:zentinel/service/pending_request_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final viewRoutes = const <Widget>[HomeView(), CategoryView(), ProfileView()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(AppLifecycleObserver());
    Future.microtask(() {
      ref.read(homeTabProvider.notifier).state = 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<User?>>(userSessionProvider, (previous, next) {
      if (previous?.value != null && next.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesión no válida. Vuelva a iniciar sesión'),
          ),
        );

        context.go('/login');
      }
    });

    
    ref.listen<GlobalInterceptorDioProvider?>(globalMessageProvider, (prev, next) {
      if (next != null) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(next.text),
            backgroundColor: next.isError ? Colors.red : Colors.green,
            duration: const Duration(seconds: 7),
          ),
        );

        ref.read(globalMessageProvider.notifier).clear();
      }
    });

    final authState = ref.watch(userSessionProvider);

    if (!authState.hasValue || authState.value == null) {
      return const SizedBox.shrink();
    }

    final userData = authState.value!;

    final index = ref.watch(homeTabProvider);
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(300),
      //   child: const CustomAppbar(),
      // ),
      // resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 11, 16, 20),
      body: SafeArea(
        top: false,
        // bottom: false,
        child: IndexedStack(
          //Widget para conservar el estado de la pagina (ej Si hace scroll dejarlo tal cual)
          index: index,
          children: viewRoutes,
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: index,
        onTap: (i) {
          ref.read(homeTabProvider.notifier).state = i;
          
          if (i == 0) {
            if (userData.hasPermission(Permissions.verIngresosBiomar)) {
              ref.read(getHistoryEntryAccess.notifier).load();
              ref.read(graphDispatchProvider.notifier).load();
            }

            if (userData.hasPermission(Permissions.verDespachos)) {
              ref.read(getHistoryDispatch.notifier).load();
              ref.read(graphDispatchProvider.notifier).load();
            }
            
            if (userData.hasPermission(Permissions.verBitacoras)) {
              ref.read(getHistoryLogbooks.notifier).load();
              ref.read(graphLogbookProvider.notifier).load();
            }
          }
        },
      ),
    );
  }
}
