import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_task_umg/screens/initial_screen.dart';
import 'package:todo_task_umg/screens/login_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return MaterialPage(child: InitialScreen());
      },
      routes: <GoRoute>[
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) {
            return MaterialPage(child: LoginScreen());
          },
        ),
      ]
    ),
  ],
);
