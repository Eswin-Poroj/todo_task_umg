import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: [
            TextScreen('Tareas Zen', 48),
            Image.asset('images/logo.png', height: 200, width: 200),
            Column(
              children: [
                TextScreen('Gestor de Tareas', 32.0),
                TextScreen('&', 32.0),
                TextScreen('Lista de Pendientes', 32.0),
              ],
            ),
            Text('¡Organiza tu día, conquista tus metas!'),
            Text(
              '-TareaZen',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            ElevatedButton.icon(
              onPressed: () {
                context.goNamed('login');
              },
              label: Text('INICIAR SESIÓN'),
              icon: Icon(Icons.login),
            ),
            ElevatedButton.icon(
              onPressed: () {
                context.goNamed('register');
              },
              label: Text('REGISTRARSE'),
              icon: Icon(Icons.arrow_upward),
            ),
          ],
        ),
      ),
    );
  }
}

class TextScreen extends StatelessWidget {
  final String title;
  final double sizeText;

  const TextScreen(this.title, this.sizeText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: sizeText, fontWeight: FontWeight.w900),
    );
  }
}
