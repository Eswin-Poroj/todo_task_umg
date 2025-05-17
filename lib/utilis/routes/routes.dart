import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:todo_task_umg/models/task.dart';
import 'package:todo_task_umg/screens/task/add_task_screen.dart';
import 'package:todo_task_umg/screens/task/home_screen.dart';
import 'package:todo_task_umg/screens/initial_screen.dart';
import 'package:todo_task_umg/screens/task/update_screen.dart';
import 'package:todo_task_umg/screens/users/login_screen.dart';
import 'package:todo_task_umg/screens/users/profile_screen.dart';
import 'package:todo_task_umg/screens/users/registrer_screen.dart';

// Definición de nombres de rutas
class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String addTask = '/add-task';
  static const String updateTask = '/update-task';
  static const String profile = '/profile';
}

final GoRouter router = GoRouter(
  observers: [GoTransition.observer],
  initialLocation: AppRoutes.initial,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.initial,
      name: 'initial',
      builder: (_, __) => const InitialScreen(),
    ),
    // Rutas de autenticación
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
      pageBuilder: GoTransitions.fade.withFade.toBottom.call,
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const RegistrerScreen(),
      pageBuilder: GoTransitions.fade.call,
    ),
    // Rutas de la aplicación (autenticadas)
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
      pageBuilder: GoTransitions.fade.call,
    ),
    GoRoute(
      path: AppRoutes.addTask,
      name: 'addTask',
      builder: (context, state) => const AddTaskScreen(),
      pageBuilder: GoTransitions.dialog.call,
    ),
    GoRoute(
      path: AppRoutes.updateTask,
      name: 'updateTask',
      builder: (context, state) => UpdateScreen(task: state.extra as Task?),
      pageBuilder: GoTransitions.dialog.call,
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
      pageBuilder: GoTransitions.fade.call,
    ),
  ],
);
