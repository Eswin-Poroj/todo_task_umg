import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo_task_umg/models/task.dart';
import 'package:http/http.dart' as http;
import 'package:todo_task_umg/services/api_config.dart';

class ServicesTask extends ChangeNotifier {
  List<Task> tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get allTasks => tasks;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> getTaskByUser(String userID) async {
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        tasks.add(newTask);
        _error = null;
        _isLoading = false;
        notifyListeners();
      } else {
        _error = 'Failed to create task';
        _isLoading = false;
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
