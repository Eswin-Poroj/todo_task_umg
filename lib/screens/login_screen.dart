import 'package:flutter/material.dart';
import 'package:todo_task_umg/utilis/theme/colors_app.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.background,
      appBar: AppBar(
        title: Text('hola'),
      ),
    );
  }
}