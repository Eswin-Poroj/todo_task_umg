import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:todo_task_umg/models/user.dart';
import 'package:todo_task_umg/services/api_config.dart';

class ServicesUser extends ChangeNotifier {
  List<User> _users = [];
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  List<User> get users => _users;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDataUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(ApiConfig.usersEndpoint);
      if (response.statusCode == 200) {
        _users =
            (json.decode(response.body) as List)
                .map((data) => User.fromJson(data))
                .toList();
        _isLoading = false;
        notifyListeners();
      } else {
        _error = 'Failed to load user data: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Error loading user list: ${e.toString()}';
      notifyListeners();
      throw Exception(_error);
    }
  }

  Future<void> createUser(String email, String user, String pass) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(ApiConfig.createUserEndpoint,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'user': user, 'pass': pass}),
      );
      if (response.statusCode == 200) {
        _error = 'User created successfully';
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        _error = json.decode(response.body)['error'];
        notifyListeners();
        throw Exception('Error creating user: ${response.statusCode}');
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Error creating user: ${e.toString()}';
      notifyListeners();
      throw Exception(_error);
    }
  }

  Future<void> loginUser(String email, String pass) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await fetchDataUser();
      // verificamos si en la lista qué devuelve contiene esos dos parametros
      final user = _users.firstWhere(
        (user) => user.email == email && user.pass == pass,
        orElse: () => User(email: '', pass: '', user: ''),
      );

      if (user.email.isNotEmpty) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
      } else {
        _error = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        throw Exception(_error);
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Error during login: ${e.toString()}';
      notifyListeners();
      throw Exception(_error);
    }
  }
}
