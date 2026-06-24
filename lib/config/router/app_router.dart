import 'package:zentinel/domain/entities/all_dispatch.dart';
import 'package:zentinel/domain/entities/entry_access_control.dart';
import 'package:zentinel/domain/entities/purchase_order.dart';
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
          builder: (context, state) {
            final filters = state.extra as dynamic;
            return LogbookListScreen(
              filtersLogbook: filters,
            );
          },
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
          path: 'list-employee-intern',
          name: EmployeeInternListScreen.name,
          builder: (context, state) => const EmployeeInternListScreen()
        ),
        GoRoute(
          path: 'list-employee-movements',
          name: EmployeeMovementScreen.name,
          builder: (context, state) {
            final filters = state.extra as dynamic;
            return EmployeeMovementScreen(
              filtersMovement: filters,
            );
          },
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
        ),
        GoRoute(
          path: 'new-dispatch',
          name: NewDispatchScreen.name,
          builder: (context, state) {
            final isProductTerm = state.extra as dynamic;
            return NewDispatchScreen(
              isProductTerm: isProductTerm,
            );
          },
        ),
        GoRoute(
          path: 'new-employee',
          name: NewEmployeeScreen.name,
          builder: (context, state) => const NewEmployeeScreen()
        ),
        GoRoute(
          path: 'new-employee-movement',
          name: NewEmployeeMovementScreen.name,
          builder: (context, state) {
            final params = state.extra as EmployeeMovementArgs;
            return NewEmployeeMovementScreen(
              typeMovement: params.typeMovement,
              idEmployee: params.idEmployee,
            );
          },
        ),
        GoRoute(
          path: 'new-black-list',
          name: NewBlackListScreen.name,
          builder: (context, state) => const NewBlackListScreen()
        ),
        GoRoute(
          path: 'list-blacklist',
          name: BacklistListScreen.name,
          builder: (context, state) => const BacklistListScreen()
        ),
        GoRoute(
          path: 'new-purchase-order',
          name: NewPurchaseOrderScreen.name,
          builder: (context, state) => const NewPurchaseOrderScreen()
        ),
        GoRoute(
          path: 'list-purchase-order',
          name: ListPurchaseOrderScreen.name,
          builder: (context, state) => const ListPurchaseOrderScreen()
        ),
        GoRoute(
          path: 'register-quantity-order',
          name: RegisterQuantityScreen.name,
          builder: (context, state) {
            final purchaseOrderData = state.extra as PurchaseOrder;
            return RegisterQuantityScreen(
              purchaseOrder: purchaseOrderData,
            );
          },
        ),
      ]
    ),
  ]
);