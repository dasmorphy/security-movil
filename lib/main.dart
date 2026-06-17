import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:zentinel/config/router/app_router.dart';
import 'package:zentinel/config/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/data/services/hive_service.dart';
import 'package:zentinel/service/local_storage.dart';
import 'package:zentinel/service/pending_request_service.dart';
import 'package:zentinel/presentation/widgets/shared/sync_listener.dart';
import 'package:zentinel/presentation/providers/sync_pending/sync_pending_provider.dart';

final syncService = SyncService();

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  Intl.defaultLocale = 'es_ES';
  final hiveService = HiveService();
  await hiveService.initHive();
  // await initHive();
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // no pinta fondo
      statusBarIconBrightness: Brightness.dark, // Android
      statusBarBrightness: Brightness.dark, // iOS
    ),
  );

    runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;
  late AppLifecycleObserver _lifecycleObserver;
  // final scaffoldMessengerKeyy = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    _localization.init(
      mapLocales: const [
        MapLocale('en', AppLocale.EN),
        MapLocale('es', AppLocale.ES),
      ],
      initLanguageCode: 'es',
    );

    _localization.onTranslatedLanguage = (_) {
      setState(() {});
    };

    // 🔄 Callback para sincronizar cuando hay internet
    void onSyncNeeded() {
      print('📡 Internet disponible, iniciando sincronización...');
      // syncAll() serializa los 3 boxes bajo un único lock.
      ref.read(syncPendingProvider.notifier).syncAll();
    }

    // 🔄 Inicializar el SyncService con el callback
    // syncService.start(onSyncNeeded: onSyncNeeded);

    // 👁️ Registrar el lifecycle observer para sincronizar cuando el app vuelve a primer plano
    _lifecycleObserver = AppLifecycleObserver(
      onResume: () {
      print('📱 App resumed, verificando sincronización...');
      onSyncNeeded(); // antes era `onSyncNeeded;` (no invocaba nada)
    });
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void dispose() {
    // syncService.dispose();
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SyncListener(
      child: MaterialApp.router(
        scaffoldMessengerKey: scaffoldMessengerKey,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        supportedLocales: _localization.supportedLocales,
        localizationsDelegates: [
          ..._localization.localizationsDelegates,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme().getTheme(),
      ),
    );
  }
}

mixin AppLocale {
  static const String title = 'title';
  static const String thisIs = 'thisIs';

  static const Map<String, dynamic> EN = {
    title: 'Localization',
    thisIs: 'This is %a package, version %a.',
  };

  static const Map<String, dynamic> ES = {
    title: 'Localización',
    thisIs: 'Este es el paquete %a, versión %a.',
  };
}
