import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_task_umg/services/services_task.dart';
import 'package:todo_task_umg/services/services_user.dart';
import 'package:todo_task_umg/utilis/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _tasksFuture = Future.value();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userService = Provider.of<ServicesUser>(context, listen: false);
      final taskService = Provider.of<ServicesTask>(context, listen: false);

      if (userService.currentUser != null) {
        _tasksFuture = taskService.getTaskByUser(1);
      }
    });
  }

  String _getTaskTimeLabel(String? dateTime) {
    if (dateTime == null) return 'Todo El Día';

    final DateTime parsedDate = DateTime.parse(dateTime);
    final DateTime now = DateTime.now();

    // Check if the date is today
    if (parsedDate.year == now.year &&
        parsedDate.month == now.month &&
        parsedDate.day == now.day) {
      return '${parsedDate.hour}:${parsedDate.minute.toString().padLeft(2, '0')} am';
    }

    // Check if the date is tomorrow
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    if (parsedDate.year == tomorrow.year &&
        parsedDate.month == tomorrow.month &&
        parsedDate.day == tomorrow.day) {
      return 'Para mañana';
    }

    // Check if the date is in the past
    if (parsedDate.isBefore(now)) {
      return 'Tarea Atrasada desde ${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    }

    // Check if the date is in the future
    if (parsedDate.isAfter(now)) {
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    }

    // Return 'Todo El Día' if the date is not today, tomorrow, in the past, or in the future
    return 'Todo El Día';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/logo.png', height: 44),
            Text('TAREAS ZEN'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outlined),
            onPressed: () {
              // Handle the add task action
              print('Button pressed');
            },
          ),
        ],
      ),
      drawer: drawerApp(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Plan de Tareas: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading tasks'));
                } else {
                  return Consumer<ServicesTask>(
                    builder: (context, taskServices, child) {
                      final taskList = taskServices.allTasks;
                      final bool isLoading = taskServices.isLoading;
                      final user =
                          Provider.of<ServicesUser>(
                            context,
                            listen: false,
                          ).currentUser;
                      return isLoading
                          ? Center(
                            child: Text(
                              'Cargando las tareas de ${user?.username}',
                              style: TextStyle(
                                fontSize: 26,
                                color: Colors.grey,
                              ),
                            ),
                          )
                          : ListView.builder(
                            itemCount: taskList.length,
                            itemBuilder: (context, index) {
                              final task = taskList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF5D4A9C),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.check),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _getTaskTimeLabel(
                                                  task.dueDatetime,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              Text(
                                                task.title,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.chevron_right),
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here
        },
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        hoverColor: Colors.grey[700],
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
