import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_task_umg/services/services_task.dart';
import 'package:todo_task_umg/services/services_user.dart';

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
    final taskServices = Provider.of<ServicesTask>(context);

    Future.microtask(() => taskServices.getTaskByUser(currentUser!.id));

    Color getPriorityColor(int priority) {
      switch (priority) {
        case 1:
          return Colors.red;
        case 2:
          return Colors.orange;
        case 3:
          return Colors.green;
        default:
          return Colors.blue;
      }
    }

    String _formatDate(String? date) {
      if (date == null) return '';
      final DateTime parsedDate = DateTime.parse(date);
      return '${parsedDate.day}/${parsedDate.month}';
    }

    return Consumer<ServicesTask>(
      builder: (context, taskServices, child) {
        final taskList = taskServices.allTasks;
        final bool isLoading = taskServices.isLoading;
        return Scaffold(
          body: SafeArea(
            child:
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : taskList.isEmpty
                    ? Center(child: Text('No hay tareas pendientes'))
                    : ListView.builder(
                      itemCount: taskList.length,
                      itemBuilder: (context, index) {
                        final task = taskList[index];
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: getPriorityColor(task.priority),
                              child: Icon(
                                Icons.assignment,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(task.title),
                            subtitle: Text(
                              task.details.isEmpty
                                  ? "Sin detalles"
                                  : task.details,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_formatDate(task.dueDatetime)),
                                SizedBox(width: 8),
                                Icon(
                                  task.isFavorite == 1
                                      ? Icons.star
                                      : Icons.star_border,
                                  color:
                                      task.isFavorite == 1
                                          ? Colors.amber
                                          : null,
                                ),
                              ],
                            ),
                            onTap: () {
                              // Aquí puedes agregar la navegación a la pantalla de detalles
                            },
                          ),
                        );
                      },
                    ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Aquí puedes agregar la acción para crear una nueva tarea
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
