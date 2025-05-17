import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_task_umg/services/services_task.dart';
import 'package:todo_task_umg/services/services_user.dart';
import 'package:todo_task_umg/utilis/widgets/drawer.dart';
import 'package:fl_chart/fl_chart.dart';

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

    // Check if the date is within the next 3 days
    final threeDaysLater = DateTime(now.year, now.month, now.day + 3);
    if (parsedDate.isBefore(threeDaysLater)) {
      return 'Faltan ${parsedDate.difference(now).inDays + 1} días';
    }

    // Return date for future tasks
    return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas Zen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outlined),
            onPressed: () {
              context.pushNamed('profile');
            },
          ),
        ],
      ),
      drawer: drawerApp(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Text(
              'Plan De Tareas: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
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

                      if (isLoading) {
                        return Center(
                          child: Text(
                            'Cargando las tareas de ${user?.username}',
                            style: const TextStyle(
                              fontSize: 26,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: ListView.builder(
                              itemCount: taskList.length,
                              itemBuilder: (context, index) {
                                final task = taskList[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 4.0,
                                  ),
                                  child: Card(
                                    elevation: 0,
                                    margin: EdgeInsets.zero,
                                    color: Colors.transparent,
                                    child: ListTile(
                                      leading: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF5D4A9C),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                      title: Text(
                                        _getTaskTimeLabel(task.dueDatetime),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      subtitle: Text(
                                        task.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.chevron_right),
                                        onPressed: () {
                                          context.pushNamed(
                                            'updateTask',
                                            extra: task,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Estructura de Tareas',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'ÚLTIMOS 30 DÍAS',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 150,
                                  child: Consumer<ServicesTask>(
                                    builder: (context, taskService, _) {
                                      // Calcular las estadísticas
                                      final totalTasks =
                                          taskService.allTasks.length;
                                      final completedTasks =
                                          taskService.allTasks
                                              .where(
                                                (task) =>
                                                    task.status == 'completada',
                                              )
                                              .length;
                                      final pendingTasks =
                                          taskService.allTasks
                                              .where(
                                                (task) =>
                                                    task.status == 'pendiente',
                                              )
                                              .length;
                                      final favoriteTasks =
                                          taskService.allTasks
                                              .where(
                                                (task) => task.isFavorite == 1,
                                              )
                                              .length;
                                      final deletedTasks =
                                          0; // No tenemos esta info, podemos mantenerlo en 0

                                      // Si no hay tareas, mostrar un gráfico vacío
                                      if (totalTasks == 0) {
                                        return Center(
                                          child: Text(
                                            'No hay tareas para mostrar',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      }

                                      return Row(
                                        children: [
                                          Expanded(
                                            child: PieChart(
                                              PieChartData(
                                                sections: [
                                                  PieChartSectionData(
                                                    value:
                                                        pendingTasks.toDouble(),
                                                    color: Colors.amber,
                                                    title: '',
                                                    radius: 50,
                                                  ),
                                                  PieChartSectionData(
                                                    value:
                                                        deletedTasks > 0
                                                            ? deletedTasks
                                                                .toDouble()
                                                            : 1,
                                                    color: Colors.red,
                                                    title: '',
                                                    radius: 50,
                                                  ),
                                                  PieChartSectionData(
                                                    value:
                                                        completedTasks
                                                            .toDouble(),
                                                    color: Colors.blue,
                                                    title: '',
                                                    radius: 50,
                                                  ),
                                                  PieChartSectionData(
                                                    value:
                                                        favoriteTasks
                                                            .toDouble(),
                                                    color: Colors.teal,
                                                    title: '',
                                                    radius: 50,
                                                  ),
                                                ],
                                                centerSpaceRadius: 30,
                                                sectionsSpace: 0,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildLegendItem(
                                                'Completadas: $completedTasks',
                                                Colors.blue,
                                              ),
                                              const SizedBox(height: 8),
                                              _buildLegendItem(
                                                'No Completadas: $pendingTasks',
                                                Colors.amber,
                                              ),
                                              const SizedBox(height: 8),
                                              _buildLegendItem(
                                                'Favoritas: $favoriteTasks',
                                                Colors.teal,
                                              ),
                                              const SizedBox(height: 8),
                                              _buildLegendItem(
                                                'Eliminadas: $deletedTasks',
                                                Colors.red,
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
          context.goNamed('addTask');
        },
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        hoverColor: Colors.grey[700],
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
