import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:todo_task_umg/screens/home_screen.dart';
import 'package:todo_task_umg/screens/initial_screen.dart';
import 'package:todo_task_umg/screens/login_screen.dart';
import 'package:todo_task_umg/screens/registrer_screen.dart';

final GoRouter router = GoRouter(
  observers: [GoTransition.observer],
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (_, _) => const InitialScreen(),
      routes: <GoRoute>[
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
          pageBuilder: GoTransitions.fade.withFade.toBottom.call,
          routes: <GoRoute>[
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
              pageBuilder: GoTransitions.fade.call,
            ),
          ],
        ),
        GoRoute(
          path: '/registrer',
          builder: (context, state) => const RegistrerScreen(),
          pageBuilder: GoTransitions.fade.call,
        ),
      ],
    ),
  ],
);
