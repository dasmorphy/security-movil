import 'package:zentinel/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login-screen',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'depature-report',
          name: DepatureReportFormScreen.name,
          // builder: (context, state) => DepatureReportFormScreen()
        )
      ]
    ),

    GoRoute(
      path: '/',
      redirect: (_, __) => '/home',
    )

  ]
);