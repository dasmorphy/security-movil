import 'package:zentinel/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: SplashScreen.name,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: OnboardingScreen.name,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'personal-data',
          name: PersonalDataScreen.name,
          builder: (context, state) => const PersonalDataScreen()
        ),
        GoRoute(
          path: 'change-email',
          name: ChangeEmailScreen.name,
          builder: (context, state) => const ChangeEmailScreen()
        ),
        GoRoute(
          path: 'check-success',
          name: CheckSuccessScreen.name,
          builder: (context, state) {
            final redirect = state.uri.queryParameters['redirect'];
            return CheckSuccessScreen(
              redirectRoute: redirect,
            );
          },
        ),
        GoRoute(
          path: 'list-logbooks',
          name: LogbookListScreen.name,
          builder: (context, state) => const LogbookListScreen()
        )
      ]
    ),
  ]
);