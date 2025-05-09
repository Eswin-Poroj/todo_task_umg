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
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> userJson = json.decode(response.body);

        _users =
            userJson
                .map(
                  (userData) => User(
                    id: userData['id'],
                    email: userData['email'],
                    username: userData['username'],
                    password: userData['password'],
                  ),
                )
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
      final response = await http.post(
        ApiConfig.createUserEndpoint,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'user': user, 'pass': pass}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        _error = 'User created successfully';
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        _error = json.decode(response.body)['error'];
        notifyListeners();
        throw Exception('Error creating user: ${response.body}');
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Fallo en ${e.toString()}';
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
      final userExist = _users.firstWhere(
        (user) => user.email == email && user.password == pass,
        orElse: () => User(id: 0, email: '', username: '', password: ''),
      );

      if (userExist.id != 0) {
        _currentUser = userExist;
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

  Future<void> logoutUser() async {
    _currentUser = null;
    notifyListeners();
  }
}
