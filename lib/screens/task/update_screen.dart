import 'package:flutter/material.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pantalla de Actualización')),
      body: Container(
        child: Column(
          children: [
            Image.asset('images/logo.png'),
            ElevatedButton(
              onPressed: () {
                print('Hola mundo');
              },
              child: Icon(Icons.update),
            ),
          ],
        ),
      ),
    );
  }
}
