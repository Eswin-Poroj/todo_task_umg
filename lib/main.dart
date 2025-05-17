import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_task_umg/screens/users/registrer_screen.dart';
import 'package:todo_task_umg/services/services_task.dart';
import 'package:todo_task_umg/services/services_user.dart';
import 'package:todo_task_umg/utilis/routes/routes.dart';
import 'package:todo_task_umg/utilis/theme/theme_data_app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServicesUser()),
        ChangeNotifierProvider(create: (_) => PasswordVisibilityProvider()),
        ChangeNotifierProvider(create: (_) => ServicesTask()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Todo-Task',
      theme: ThemeDataApp.themeData(),
      debugShowCheckedModeBanner: false,
    );
  }
}
