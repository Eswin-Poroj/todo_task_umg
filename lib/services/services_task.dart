import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo_task_umg/models/task.dart';
import 'package:http/http.dart' as http;
import 'package:todo_task_umg/services/api_config.dart';

class ServicesTask extends ChangeNotifier {
  List<Task> tasks = [];
  bool _isLoading = false;
  String? _error;
  String? _message;

  List<Task> get allTasks => tasks;
  String? get error => _error;
  bool get isLoading => _isLoading;
  String? get message => _message;

  Future<void> getTaskByUser(int userID) async {
    _isLoading = true;
    try {
      final response = await http.get(
        ApiConfig.getTasksByUserEndpoint(userID),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> taskJson = json.decode(response.body);
        tasks = taskJson.map((json) => Task.fromJson(json)).toList();
        _error = null;
        _isLoading = false;
        notifyListeners();
      } else {
        _error = 'Failed to load tasks';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners(); // Added notifyListeners() here to update listeners on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTask(Task task) async {
    _isLoading = true;
    notifyListeners();

    try {
      final Task newTask = Task(
        userId: task.userId,
        title: task.title,
        details: task.details,
        dueDatetime: task.dueDatetime,
        isFavorite: task.isFavorite,
        status: task.status,
        priority: task.priority,
      );

      final response = await http.post(
        ApiConfig.createTaskEndpoint,
        headers: {'Content-Type': 'application/json'},
        body: newTask.toJson(),
      );

      print("API Response: ${response.body}");
      print("Status Code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        // Añadir la tarea creada (con id) a la lista local
        if (responseData['id'] != null) {
          final createdTask = Task(
            id: responseData['id'],
            userId: task.userId,
            title: task.title,
            details: task.details,
            dueDatetime: task.dueDatetime,
            isFavorite: task.isFavorite,
            status: task.status,
            priority: task.priority,
          );
          tasks.add(createdTask);
        } else {
          _error = 'Error al crear la tarea: ID no recibido';
        }
        _error = null;
        _message = "Tarea creada correctamente";
      } else {
        _error = 'Error al crear la tarea: ${response.reasonPhrase}';
        _message = response.body.toString();
      }
    } catch (e) {
      _error = 'Error de excepción: ${e.toString()}';
      _message = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTask(Task task) async {
    _isLoading = true;
    try {
      final Task updateTask = Task(
        userId: task.userId,
        title: task.title,
        details: task.details,
        isFavorite: task.isFavorite,
        status: task.status,
        priority: task.priority,
        id: task.id,
        dueDatetime: task.dueDatetime,
      );

      final response = await http.put(
        ApiConfig.updateTaskByIdEndpoint(task.id!),
        headers: {'Content-Type': 'application/json'},
        body: updateTask.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _error = null;
        _isLoading = false;
        _message = response.body;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
