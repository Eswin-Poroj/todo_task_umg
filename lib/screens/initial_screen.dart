import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        flex: 1,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tareas Zen',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              Image.asset('images/logo.png'),
              Column(
                children: [
                  textScreen('Gestor de Tareas', 32.0),
                  textScreen('&', 32.0),
                  textScreen('Lista de Pendientes', 32.0),
                ],
              ),
              ElevatedButton(onPressed: () {}, child: Text('Start Task')),
            ],
          ),
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
      style: TextStyle(
        fontSize: sizeText,
        fontFamily: GoogleFonts.roboto().fontFamily,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
