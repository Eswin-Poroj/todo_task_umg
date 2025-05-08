import 'package:flutter/material.dart';

class WidgetDrawer extends StatelessWidget {
  const WidgetDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Header'),
          ),
          ListTile(title: Text('Item 1'), onTap: () {}),
          ListTile(title: Text('Item 2'), onTap: () {}),
        ],
      ),
    );
  }
}
