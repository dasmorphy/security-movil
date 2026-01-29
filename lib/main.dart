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

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  Intl.defaultLocale = 'es_ES';
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // no pinta fondo
      statusBarIconBrightness: Brightness.dark, // Android
      statusBarBrightness: Brightness.dark, // iOS
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
