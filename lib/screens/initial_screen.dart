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
            textScreen('Tareas Zen', 48),
            Image.asset('images/logo.png', height: 200, width: 200),
            Column(
              children: [
                textScreen('Gestor de Tareas', 32.0),
                textScreen('&', 32.0),
                textScreen('Lista de Pendientes', 32.0),
              ],
            ),
            Text('¡Organiza tu día, conquista tus metas!'),
            Text(
              '-TareaZen',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            ElevatedButton.icon(
              onPressed: () {
                context.go('/login');
              },
              label: Text('INICIAR SESIÓN'),
              icon: Icon(Icons.login),
            ),
            ElevatedButton.icon(
              onPressed: () {
                context.go('/registrer');
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

class textScreen extends StatelessWidget {
  final String title;
  final double sizeText;

  const textScreen(this.title, this.sizeText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: sizeText, fontWeight: FontWeight.w900),
    );
  }
}
