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
    ),
      // routes: [
      //   GoRoute(
      //     path: 'movie/:id',
      //     name: MovieScreen.name,
      //     builder: (context, state) {
      //       final movieID = state.pathParameters['id'] ?? 'no-id';
      //       return MovieScreen(movieId: movieID);
      //     }
      //   )
      // ]

    GoRoute(
      path: '/',
      redirect: (_, __) => '/home',
    )

  ]
);