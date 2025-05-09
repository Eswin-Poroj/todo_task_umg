import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_task_umg/services/services_user.dart';
import 'package:todo_task_umg/utilis/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userServices = Provider.of<ServicesUser>(context);
    final currentUser = userServices.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('images/logo.png'),
            SizedBox(width: 8),
            Text('TODO LIST'),
          ],
        ),
        actions: [IconButton(icon: Icon(Icons.person), onPressed: () {})],
      ),
      drawer: drawerApp(context),
      body: SafeArea(
        child: Column(
          children: [
            Text('Hello ${currentUser?.username}'),
            // Add more widgets here
          ],
        ),
      ),
    );
  }
}
