import 'package:flutter/material.dart';
import 'package:todo_task_umg/models/task.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_task_umg/services/services_task.dart';

class UpdateScreen extends StatefulWidget {
  final Task? task;
  const UpdateScreen({super.key, this.task});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _titleController;
  TextEditingController? _detailsController;
  DateTime _selectedDateTime = DateTime.now();
  bool _isSaving = false;

  // Variables para los dropdowns
  String _selectedStatus = 'pendiente';
  int _selectedPriority = 1;
  int _isFavorite = 0;

  // Opciones para los dropdowns
  final List<String> _statusOptions = [
    'pendiente',
    'en progreso',
    'cancelada',
    'completada',
  ];

  final List<Map<String, dynamic>> _priorityOptions = [
    {'value': 1, 'label': 'Baja', 'color': Colors.green},
    {'value': 2, 'label': 'Media', 'color': Colors.orange},
    {'value': 3, 'label': 'Alta', 'color': Colors.red},
  ];

  late final Task task = widget.task!;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: task.title);
    _detailsController = TextEditingController(text: task.details);
    _selectedDateTime = DateTime.parse(task.dueDatetime);

    final normalizedStatus = task.status.toLowerCase();

    if (_statusOptions.contains(normalizedStatus)) {
      _selectedStatus = normalizedStatus;
    } else {
      _selectedStatus = 'pendiente';
      task.status = _selectedStatus;
    }

    _selectedPriority = task.priority;
    _isFavorite = task.isFavorite;
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSaving = true;
      });

      final updatedTask = Task(
        id: task.id,
        userId: task.userId,
        title: _titleController!.text.trim(),
        details: _detailsController!.text.trim(),
        dueDatetime: _selectedDateTime.toString(),
        status: _selectedStatus,
        priority: _selectedPriority,
        isFavorite: _isFavorite,
      );

      try {
        final taskService = Provider.of<ServicesTask>(context, listen: false);
        await taskService.updateTask(updatedTask);

        if (taskService.error == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Tarea actualizada con éxito!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, updatedTask);
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al actualizar: ${taskService.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskService = Provider.of<ServicesTask>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('images/logo.png', height: 20, width: 20),
            const SizedBox(width: 8),
            const Text('Actualizar Tarea'),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nombre de la Tarea',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: 'Título de la tarea',
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo Requerido 📝';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('Detalles', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _detailsController,
                        decoration: const InputDecoration(
                          hintText: 'Descripción',
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo Requerido 📝';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text('Estado', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedStatus,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 16,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedStatus = newValue;
                                });
                              }
                            },
                            items:
                                _statusOptions.map<DropdownMenuItem<String>>((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value.characters.first.toUpperCase() +
                                          value.substring(1),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Prioridad', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _selectedPriority,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 16,
                            onChanged: (int? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedPriority = newValue;
                                });
                              }
                            },
                            items:
                                _priorityOptions.map<DropdownMenuItem<int>>((
                                  Map<String, dynamic> option,
                                ) {
                                  return DropdownMenuItem<int>(
                                    value: option['value'],
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: option['color'],
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          option['label'],
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Fecha',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(_selectedDateTime),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const Icon(Icons.calendar_month),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Hora',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat(
                                        'HH:mm',
                                      ).format(_selectedDateTime),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const Icon(Icons.access_time),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tarea Favorita',
                            style: TextStyle(fontSize: 16),
                          ),
                          Switch(
                            value: _isFavorite == 1,
                            onChanged: (value) {
                              setState(() {
                                _isFavorite = value ? 1 : 0;
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Seleccione si es una tarea favorita',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed:
                        (_isSaving || taskService.isLoading) ? null : _saveTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child:
                        (_isSaving || taskService.isLoading)
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.0,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text('Actualizando...'),
                              ],
                            )
                            : const Text('Actualizar Tarea'),
                  ),
                ),
              ],
            ),
          ),
          if (taskService.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
