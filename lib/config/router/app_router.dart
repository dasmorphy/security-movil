import 'package:zentinel/domain/entities/all_dispatch.dart';
import 'package:zentinel/domain/entities/entry_access_control.dart';
import 'package:zentinel/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/service/navigation_service.dart';

final appRouter = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
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
        ),
        GoRoute(
          path: 'list-dispatches',
          name: DispatchListScreen.name,
          builder: (context, state) => const DispatchListScreen()
        ),
        GoRoute(
          path: 'list-entry-access',
          name: EntryAccessListScreen.name,
          builder: (context, state) => const EntryAccessListScreen()
        ),
        GoRoute(
          path: 'confirm-dispatch',
          name: ReceptionConfirmationScreen.name,
          builder: (context, state) {
            final dispatchData = state.extra as AllDispatch;
            return ReceptionConfirmationScreen(
              dispatchData: dispatchData,
            );
          },
        ),
        GoRoute(
          path: 'update-status-dispatch',
          name: UpdateStatusDispatchScreen.name,
          builder: (context, state) {
            final dispatchData = state.extra as AllDispatch;
            return UpdateStatusDispatchScreen(
              dispatchData: dispatchData,
            );
          },
        ),
        GoRoute(
          path: 'finish-entry-access',
          name: FinishEntryAccessScreen.name,
          builder: (context, state) {
            final entryAccessData = state.extra as EntryAccessControl;
            return FinishEntryAccessScreen(
              entryAccessData: entryAccessData,
            );
          },
        )
      ]
    ),
  ]
);