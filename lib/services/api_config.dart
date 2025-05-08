class ApiConfig {
  ApiConfig({String? userId});

  static Uri baseUrl = Uri.parse('http://localhost:3000/api');

  // endpoints for user
  static Uri usersEndpoint = Uri.parse('${baseUrl.toString()}/users');
  static Uri createUserEndpoint = Uri.parse(
    '${baseUrl.toString()}/create_user',
  );

  // endpoints for task
  static Uri createTaskEndpoint = Uri.parse('${baseUrl.toString()}/createTask');
  static Uri getTasksByUserEndpoint(String userId) =>
      Uri.parse('${baseUrl.toString()}/users/$userId/tasks');
}
