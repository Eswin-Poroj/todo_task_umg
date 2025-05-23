import 'package:flutter/material.dart';

Drawer drawerApp(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.all(16.0),
      children: <Widget>[
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('images/logo.png', width: 40, height: 40),
              SizedBox(width: 8),
              Text('Tareas Zen'),
            ],
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.all(8.0),
          leading: const Icon(Icons.calendar_month),
          title: Text('Hoy'),
          onTap: () {},
        ),
        ListTile(
          contentPadding: EdgeInsets.all(8.0),
          leading: const Icon(Icons.favorite_border_outlined),
          title: Text('Favoritas'),
          onTap: () {},
        ),
        ListTile(
          contentPadding: EdgeInsets.all(8.0),
          leading: const Icon(Icons.check),
          title: Text('Completas'),
          onTap: () {},
        ),
        ListTile(title: Text('Estado')),
        ListTile(
          contentPadding: EdgeInsets.all(8.0),
          leading: const Icon(Icons.pending),
          title: Text('Pendientes'),
          onTap: () {},
        ),
        ListTile(
          contentPadding: EdgeInsets.all(8.0),
          leading: const Icon(Icons.access_time),
          title: Text('En Curso'),
          onTap: () {},
        ),
        ListTile(
          contentPadding: EdgeInsets.all(8.0),
          leading: const Icon(Icons.check),
          title: Text('Completadas'),
          onTap: () {},
        ),
        ListTile(title: Text('Prioridad')),
        ListTile(
          contentPadding: EdgeInsets.all(8.0),
          leading: const Icon(Icons.priority_high),
          title: Text('Prioridad Alta'),
          onTap: () {},
        ),
        ListTile(
          contentPadding: EdgeInsets.all(8.0),
          leading: const Icon(Icons.low_priority),
          title: Text('Prioridad Media'),
          onTap: () {},
        ),
        ListTile(
          contentPadding: EdgeInsets.all(8.0),
          leading: const Icon(Icons.access_time),
          title: Text('Prioridad Baja'),
          onTap: () {},
        ),
      ],
    ),
  );
}
